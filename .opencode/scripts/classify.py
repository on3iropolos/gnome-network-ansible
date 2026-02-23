#!/usr/bin/env python3
"""
Classify documentation units from .agent/tmp/inventory.yaml into .agent/tmp/classified.yaml.

- Assigns subject (from fixed taxonomy), type, scope, and tags.
- Detects duplicates by exact concept signature.
- Chooses a canonical unit per signature and proposes a canonical doc path.
- Output is fully machine-readable and idempotent.

This script deliberately has no external dependencies (no PyYAML).

Usage:
  1. From the repository root, run the inventory step:
       python .agent/doc_inventory.py
  2. Then classify the inventory into .agent/tmp/classified.yaml:
       python .agent/doc_classify.py

The resulting classified data can be used by downstream tools to generate or
validate canonical docs under docs/.
"""

from __future__ import annotations

import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Tuple


SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent
DOCS_ROOT = REPO_ROOT / "docs"
TMP_ROOT = REPO_ROOT / ".agent" / "tmp"
INVENTORY_PATH = TMP_ROOT / "inventory.yaml"
CLASSIFIED_PATH = TMP_ROOT / "classified.yaml"


ALLOWED_SUBJECTS = {
    "policies",
    "architecture",
    "roles",
    "inventories",
    "networking",
    "ansible",
    "testing",
    "operations",
    "security",
    "decisions",
    "troubleshooting",
    "workflows",
    "conventions",
    "reference",
    "how-to",
}

DEFAULT_SUBJECT = "reference"


@dataclass
class InventoryUnit:
    id: str
    title: str
    snippet: str
    signature: str
    candidate_subject: str
    candidate_slug: str
    sources: List[str]


@dataclass
class ClassifiedUnit:
    id: str
    title: str
    snippet: str
    signature: str
    subject: str
    slug: str
    type: str
    scope: str
    tags: List[str]
    sources: List[str]
    canonical_doc: str
    canonical: bool
    candidate_subject: str = ""
    candidate_slug: str = ""


def unescape_yaml_string(raw: str) -> str:
    """
    Reverse the very small escaping scheme used by doc_inventory.py.

    Input is a YAML double-quoted scalar like:
      "foo bar\\n\"baz\""
    """
    value = raw.strip()
    if not (value.startswith('"') and value.endswith('"')):
        return value.strip()

    inner = value[1:-1]
    # Reverse encoding order from doc_inventory.yaml writer:
    #   replace("\\", "\\\\").replace('"', '\\"'); then replace("\n", "\\n")
    inner = inner.replace("\\n", "\n")
    inner = inner.replace('\\"', '"')
    inner = inner.replace("\\\\", "\\")
    return inner


def parse_inventory() -> List[InventoryUnit]:
    """
    Very small, structure-aware parser for docs/inventory.yaml.

    Assumes the exact format emitted by doc_inventory.py:

    units:
      - id: "u0001"
        title: "..."
        snippet: "..."
        signature: "..."
        candidate_subject: "..."
        candidate_slug: "..."
        sources:
          - "path:line-line"
    """
    if not INVENTORY_PATH.exists():
        raise FileNotFoundError(f"Missing inventory file: {INVENTORY_PATH}")

    with INVENTORY_PATH.open("r", encoding="utf-8") as f:
        lines = [line.rstrip("\n") for line in f]

    units: List[InventoryUnit] = []
    i = 0
    n = len(lines)

    while i < n:
        line = lines[i]
        if not line.strip() or line.strip() == "units:":
            i += 1
            continue

        if line.startswith("  - id: "):
            # Expect fixed field order as written by doc_inventory.py
            # id
            id_value = unescape_yaml_string(line.split(":", 1)[1])

            # title, snippet, signature, candidate_subject, candidate_slug
            if i + 5 >= n:
                break

            title_line = lines[i + 1]
            snippet_line = lines[i + 2]
            signature_line = lines[i + 3]
            subject_line = lines[i + 4]
            slug_line = lines[i + 5]

            title_value = unescape_yaml_string(title_line.split(":", 1)[1])
            snippet_value = unescape_yaml_string(snippet_line.split(":", 1)[1])
            signature_value = unescape_yaml_string(signature_line.split(":", 1)[1])
            candidate_subject = unescape_yaml_string(subject_line.split(":", 1)[1])
            candidate_slug = unescape_yaml_string(slug_line.split(":", 1)[1])

            # sources header
            if i + 6 >= n:
                break

            sources_header = lines[i + 6].strip()
            if not sources_header.startswith("sources:"):
                # Invalid/changed format; bail early
                raise ValueError(
                    f"Unexpected inventory format near line {i+7}: {sources_header!r}"
                )

            # Collect sources list
            sources: List[str] = []
            j = i + 7
            while j < n:
                src_line = lines[j]
                if src_line.startswith("      - "):
                    value_part = src_line.split("-", 1)[1].strip()
                    src_value = unescape_yaml_string(value_part)
                    sources.append(src_value)
                    j += 1
                    continue
                # Next unit or end of list
                if src_line.startswith("  - id: ") or not src_line.strip():
                    break
                # Unexpected indentation; stop reading sources
                break

            units.append(
                InventoryUnit(
                    id=id_value,
                    title=title_value,
                    snippet=snippet_value,
                    signature=signature_value,
                    candidate_subject=candidate_subject,
                    candidate_slug=candidate_slug,
                    sources=sources,
                )
            )

            i = j
            continue

        i += 1

    return units


def normalize_subject(unit: InventoryUnit, path: str, text: str) -> str:
    cand = (unit.candidate_subject or "").strip().lower()
    title_lower = unit.title.lower()
    text_lower = text.lower()

    # Hard overrides based on content
    if "architecture" in title_lower or "architecture" in text_lower:
        return "architecture"
    if "policy" in title_lower or "guideline" in title_lower:
        return "policies"
    if "decision" in title_lower or "trade-off" in text_lower:
        return "decisions"
    if "troubleshooting" in title_lower:
        return "troubleshooting"
    if "workflow" in title_lower:
        return "workflows"

    # Path-based hints
    if path.startswith("roles/"):
        return "roles"
    if path.startswith("inventories/"):
        return "inventories"
    if path in {"README.md", "AGENTS.md", "DEVELOPMENT.md"}:
        # mixed content, but repo-wide
        return "reference"
    if path.startswith(".agent/"):
        # internal agent docs
        return "policies"

    if cand in ALLOWED_SUBJECTS:
        return cand

    # Fallbacks from content
    if "how to" in text_lower or "how-to" in text_lower or "quick start" in text_lower:
        return "how-to"
    if "test" in text_lower or "molecule" in text_lower:
        return "testing"
    if "security" in text_lower or "vault" in text_lower:
        return "security"
    if "troubleshoot" in text_lower:
        return "troubleshooting"

    return DEFAULT_SUBJECT


def classify_type(unit: InventoryUnit, path: str, text: str) -> str:
    lower_title = unit.title.lower()
    lower = text.lower()

    # Policies and guidelines
    if "guideline" in lower_title or "policy" in lower_title:
        return "policy"
    if path.startswith(".agent/instructions/") or path == "AGENTS.md":
        return "policy"

    # Decisions / ADR-style
    if "decision" in lower_title or "trade-offs" in lower or "alternatives considered" in lower:
        return "decision"
    if "architecture" in lower_title and "options" in lower:
        return "decision"

    # Runbooks / troubleshooting
    if "troubleshooting" in lower_title or "troubleshooting" in lower:
        return "runbook"
    if lower_title.startswith("issue:") or "issue:" in lower:
        return "runbook"
    if "phase 1:" in lower or "phase 2:" in lower or "phase 3:" in lower:
        # often operational testing procedures
        return "runbook"

    # Tutorials / how-to
    if "quick start" in lower or "getting started" in lower:
        return "tutorial"
    if "example playbook" in lower_title:
        return "how-to"
    if lower_title.startswith("1.") or lower_title.startswith("step "):
        return "how-to"
    if "### 1." in lower or "### 2." in lower:
        return "how-to"

    # Reference
    if "role variables" in lower_title or "variables" in lower_title:
        return "reference"
    if "options" in lower or "configuration file" in lower or "ansible.cfg" in lower:
        return "reference"
    if "reference" in lower_title:
        return "reference"
    if path.endswith(".cfg"):
        return "reference"

    # FAQs
    if "faq" in lower_title or "frequently asked" in lower:
        return "faq"

    # Testing / CI descriptions
    if "testing" in lower_title or "molecule" in lower:
        return "concept"

    # Default: concept/background
    return "concept"


def classify_scope(unit: InventoryUnit, path: str, text: str) -> str:
    lower = text.lower()

    if path.startswith("roles/"):
        return "role"
    if path.startswith("inventories/"):
        return "environment"
    if path.startswith(".agent/") or path in {"README.md", "AGENTS.md", "DEVELOPMENT.md"}:
        return "repo"

    if "ci/" in path or ".github/workflows/" in path:
        return "dev"
    if "testing" in lower or "molecule" in lower:
        return "qa"
    if "security" in lower or "vault" in lower or "secret" in lower:
        return "sec"
    if "runbook" in lower or "on-call" in lower or "incident" in lower:
        return "ops"

    return "repo"


def derive_tags(unit: InventoryUnit, path: str, text: str) -> List[str]:
    lower = text.lower()
    tags: List[str] = []

    def add(tag: str) -> None:
        if tag not in tags:
            tags.append(tag)

    # Technologies
    if "ansible" in lower:
        add("ansible")
    if "molecule" in lower:
        add("molecule")
    if "docker" in lower:
        add("docker")
    if "mermaid" in lower:
        add("mermaid")

    # Domain tags
    if "network" in lower or "networking" in lower:
        add("network")
    if "role" in lower or path.startswith("roles/"):
        add("role")
    if path.startswith("inventories/"):
        add("inventory")
    if "troubleshooting" in lower:
        add("troubleshooting")
    if "policy" in lower or "guideline" in lower:
        add("policy")
    if "testing" in lower:
        add("testing")
    if path.startswith(".agent/") or path == "AGENTS.md":
        add("agent")

    return tags


def classify_units(units: List[InventoryUnit]) -> Tuple[List[ClassifiedUnit], Dict[str, List[str]]]:
    sig_to_ids: Dict[str, List[str]] = {}
    id_to_unit: Dict[str, InventoryUnit] = {}

    for u in units:
        sig_to_ids.setdefault(u.signature, []).append(u.id)
        id_to_unit[u.id] = u

    classified: List[ClassifiedUnit] = []

    for u in units:
        first_source = u.sources[0] if u.sources else ""
        path = first_source.split(":", 1)[0] if first_source else ""
        text = f"{u.title}\n{u.snippet}"

        subject = normalize_subject(u, path, text)
        ctype = classify_type(u, path, text)
        scope = classify_scope(u, path, text)
        tags = derive_tags(u, path, text)

        canonical_doc = f"docs/{subject}/{u.candidate_slug}.md"
        # Canonical if this unit is the first occurrence of its signature
        canonical_ids = sig_to_ids.get(u.signature, [])
        is_canonical = bool(canonical_ids and canonical_ids[0] == u.id)

        classified.append(
            ClassifiedUnit(
                id=u.id,
                title=u.title,
                snippet=u.snippet,
                signature=u.signature,
                subject=subject,
                slug=u.candidate_slug,
                type=ctype,
                scope=scope,
                tags=tags,
                sources=u.sources,
                canonical_doc=canonical_doc,
                canonical=is_canonical,
                candidate_subject=u.candidate_subject,
                candidate_slug=u.candidate_slug,
            )
        )

    return classified, sig_to_ids


def yaml_quote(value: str) -> str:
    # Conservative: always double-quote and escape common chars.
    escaped = value.replace("\\", "\\\\").replace('"', '\\"')
    escaped = escaped.replace("\n", "\\n")
    return f'"{escaped}"'


def write_classified(
    classified: List[ClassifiedUnit],
    sig_to_ids: Dict[str, List[str]],
) -> None:
    DOCS_ROOT.mkdir(parents=True, exist_ok=True)
    with CLASSIFIED_PATH.open("w", encoding="utf-8") as f:
        f.write("units:\n")
        for cu in classified:
            f.write("  - id: " + yaml_quote(cu.id) + "\n")
            f.write("    title: " + yaml_quote(cu.title) + "\n")
            f.write("    snippet: " + yaml_quote(cu.snippet) + "\n")
            f.write("    signature: " + yaml_quote(cu.signature) + "\n")
            f.write("    subject: " + yaml_quote(cu.subject) + "\n")
            f.write("    slug: " + yaml_quote(cu.slug) + "\n")
            f.write("    type: " + yaml_quote(cu.type) + "\n")
            f.write("    scope: " + yaml_quote(cu.scope) + "\n")
            f.write("    candidate_subject: " + yaml_quote(cu.candidate_subject) + "\n")
            f.write("    candidate_slug: " + yaml_quote(cu.candidate_slug) + "\n")
            f.write("    canonical_doc: " + yaml_quote(cu.canonical_doc) + "\n")
            f.write("    canonical: " + ("true" if cu.canonical else "false") + "\n")

            # tags
            if cu.tags:
                f.write("    tags:\n")
                for tag in cu.tags:
                    f.write("      - " + yaml_quote(tag) + "\n")
            else:
                f.write("    tags: []\n")

            # sources
            f.write("    sources:\n")
            for src in cu.sources:
                f.write("      - " + yaml_quote(src) + "\n")

        # Duplicates section
        f.write("duplicates:\n")
        for signature, ids in sorted(sig_to_ids.items()):
            if len(ids) <= 1:
                continue
            canonical_id = ids[0]
            dup_ids = ids[1:]
            f.write("  - signature: " + yaml_quote(signature) + "\n")
            f.write("    canonical_id: " + yaml_quote(canonical_id) + "\n")
            f.write("    duplicate_ids:\n")
            for did in dup_ids:
                f.write("      - " + yaml_quote(did) + "\n")


def main() -> None:
    units = parse_inventory()
    classified, sig_to_ids = classify_units(units)
    write_classified(classified, sig_to_ids)


if __name__ == "__main__":
    main()