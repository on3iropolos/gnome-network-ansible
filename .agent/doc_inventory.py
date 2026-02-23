#!/usr/bin/env python3
"""Inventory documentation units across the repository into .agent/tmp/inventory.yaml.

This script is intentionally self-contained (no external dependencies)
and safe to re-run. It can be extended as the documentation system
evolves.

Usage:
  From the repository root:
    python .agent/doc_inventory.py

This will scan README/AGENTS/docs and selected comment blocks in source
files, then write a machine-readable inventory to .agent/tmp/inventory.yaml.
"""

import hashlib
import os
from dataclasses import dataclass
from pathlib import Path
from typing import List, Tuple


REPO_ROOT = Path(__file__).resolve().parent.parent
DOCS_ROOT = REPO_ROOT / "docs"
TMP_ROOT = REPO_ROOT / ".agent" / "tmp"
INVENTORY_PATH = TMP_ROOT / "inventory.yaml"


@dataclass
class SourceSpan:
    path: str
    start_line: int
    end_line: int


@dataclass
class DocUnit:
    id: str
    title: str
    snippet: str
    signature: str
    candidate_subject: str
    candidate_slug: str
    sources: List[SourceSpan]


def slugify(text: str) -> str:
    """Convert text to a filesystem-safe kebab-case slug."""
    import re

    text = text.strip().lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = re.sub(r"-+", "-", text).strip("-")
    return text or "untitled"


def normalize_for_signature(text: str) -> str:
    """Normalize text before hashing to get a concept signature."""
    import re

    text = text.lower()
    text = re.sub(r"\s+", " ", text).strip()
    return text


def short_signature(text: str) -> str:
    norm = normalize_for_signature(text)
    return hashlib.sha1(norm.encode("utf-8")).hexdigest()[:12]


def yaml_escape(value: str) -> str:
    """Return a simple double-quoted YAML string."""
    escaped = value.replace("\\", "\\\\").replace('"', '\\"')
    escaped = escaped.replace("\n", "\\n")
    return f'"{escaped}"'


def classify_subject(path: Path, text_sample: str) -> str:
    """Best-effort subject classification using path and content hints."""
    p = str(path)
    if "roles/" in p:
        return "roles"
    if "inventories/" in p:
        return "inventories"
    if "network" in p:
        return "networking"
    if "policy" in p or "policies" in p:
        return "policies"
    if "testing" in p or "molecule" in p:
        return "testing"
    if "security" in p or "sec" in p:
        return "security"
    if "troubleshoot" in p:
        return "troubleshooting"
    if "workflow" in p or "process" in p:
        return "workflows"
    # Fallbacks based on content
    lower = text_sample.lower()
    if "how to" in lower or "step-by-step" in lower:
        return "how-to"
    return "reference"


def is_text_file(path: Path) -> bool:
    try:
        with path.open("rb") as f:
            chunk = f.read(1024)
        chunk.decode("utf-8")
        return True
    except (UnicodeDecodeError, OSError):
        return False


def iter_markdown_units(path: Path) -> List[DocUnit]:
    """Extract documentation units from a Markdown file by top-level sections."""
    units: List[DocUnit] = []
    rel_path = path.relative_to(REPO_ROOT).as_posix()

    try:
        text = path.read_text(encoding="utf-8")
    except OSError:
        return units

    lines = text.splitlines()
    sections: List[Tuple[str, int, int]] = []
    current_title = None
    start = 0

    for idx, line in enumerate(lines):
        if line.startswith("#"):
            if current_title is not None:
                sections.append((current_title, start, idx))
            current_title = line.lstrip("#").strip() or "Untitled"
            start = idx

    if current_title is not None:
        sections.append((current_title, start, len(lines)))

    if not sections:
        # Treat entire file as a single unit
        content = text
        title = Path(rel_path).name
        snippet = content[:200]
        sig = short_signature(content)
        subject = classify_subject(path, content[:400])
        slug = slugify(title)
        units.append(
            DocUnit(
                id="",
                title=title,
                snippet=snippet,
                signature=sig,
                candidate_subject=subject,
                candidate_slug=slug,
                sources=[SourceSpan(rel_path, 1, len(lines))],
            )
        )
        return units

    for _, (title, start, end) in enumerate(sections):
        content = "\n".join(lines[start:end]).strip()
        if not content:
            continue
        snippet = content[:200]
        sig = short_signature(content)
        subject = classify_subject(path, content[:400])
        slug = slugify(title)
        units.append(
            DocUnit(
                id="",
                title=title,
                snippet=snippet,
                signature=sig,
                candidate_subject=subject,
                candidate_slug=slug,
                sources=[SourceSpan(rel_path, start + 1, end)],
            )
        )

    return units


def iter_comment_blocks(path: Path) -> List[DocUnit]:
    """Extract comment-block documentation units from non-Markdown text files."""
    units: List[DocUnit] = []
    rel_path = path.relative_to(REPO_ROOT).as_posix()

    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except OSError:
        return units

    def is_comment(line: str) -> bool:
        stripped = line.lstrip()
        return stripped.startswith("#") or stripped.startswith("//")

    block_lines: List[Tuple[int, str]] = []

    for idx, line in enumerate(lines):
        if is_comment(line):
            block_lines.append((idx, line))
        else:
            if block_lines:
                units.extend(_finalize_comment_block(block_lines, rel_path))
                block_lines = []

    if block_lines:
        units.extend(_finalize_comment_block(block_lines, rel_path))

    return units


def _finalize_comment_block(
    block_lines: List[Tuple[int, str]], rel_path: str
) -> List[DocUnit]:
    """Turn a raw comment block into zero or one DocUnit."""
    if len(block_lines) < 2:
        return []

    start_line = block_lines[0][0]
    end_line = block_lines[-1][0]
    raw = "\n".join(line.lstrip().lstrip("#/ ") for _, line in block_lines).strip()

    if len(raw) < 80:
        return []

    snippet = raw[:200]
    sig = short_signature(raw)
    subject = classify_subject(Path(rel_path), raw[:400])

    # Title: first sentence or first line
    first_line = raw.splitlines()[0]
    title = first_line.strip().rstrip(".")
    if len(title) > 80:
        title = title[:77] + "..."

    slug = slugify(title)

    unit = DocUnit(
        id="",
        title=title,
        snippet=snippet,
        signature=sig,
        candidate_subject=subject,
        candidate_slug=slug,
        sources=[SourceSpan(rel_path, start_line + 1, end_line + 1)],
    )

    return [unit]


def walk_repo() -> List[DocUnit]:
    units: List[DocUnit] = []

    for root, dirs, files in os.walk(REPO_ROOT):
        root_path = Path(root)
        # Prune directories in-place
        pruned = []
        for d in dirs:
            if d in {".git", "__pycache__"}:
                continue
            if root_path.name == ".agent" and d == "log":
                continue
            pruned.append(d)
        dirs[:] = pruned

        for name in files:
            path = Path(root) / name
            rel_path = path.relative_to(REPO_ROOT)

            # Skip generated documentation artifacts
            if rel_path.as_posix().startswith("docs/"):
                continue

            if not is_text_file(path):
                continue

            if path.suffix.lower() == ".md":
                units.extend(iter_markdown_units(path))
            else:
                units.extend(iter_comment_blocks(path))

    # Assign stable IDs
    for idx, unit in enumerate(units, start=1):
        unit.id = f"u{idx:04d}"

    return units


def write_inventory(units: List[DocUnit]) -> None:
    TMP_ROOT.mkdir(parents=True, exist_ok=True)
    with INVENTORY_PATH.open("w", encoding="utf-8") as f:
        f.write("units:\n")
        for unit in units:
            src_strings = [
                f"{s.path}:{s.start_line}-{s.end_line}" for s in unit.sources
            ]
            f.write("  - id: " + yaml_escape(unit.id) + "\n")
            f.write("    title: " + yaml_escape(unit.title) + "\n")
            f.write("    snippet: " + yaml_escape(unit.snippet) + "\n")
            f.write("    signature: " + yaml_escape(unit.signature) + "\n")
            f.write("    candidate_subject: " + yaml_escape(unit.candidate_subject) + "\n")
            f.write("    candidate_slug: " + yaml_escape(unit.candidate_slug) + "\n")
            f.write("    sources:\n")
            for src in src_strings:
                f.write("      - " + yaml_escape(src) + "\n")


def main() -> None:
    units = walk_repo()
    write_inventory(units)


if __name__ == "__main__":
    main()