#!/usr/bin/env python3
"""
Minimal policy manifest audit.

- Validates that docs/agent/policies/agent-policy-manifest.yaml is well-formed YAML.
- Confirms that each canonical_doc path exists relative to the repo root.
- Optionally warns about unreferenced policy markdown files under docs/agent/policies/.

This script is structural only and does not generate or change policy content.
For canonical policy definitions, see docs/agent/policies/ and the manifest docs.

Usage (from repo root):
  python .agent/policy_audit.py
"""

import sys
import yaml
from pathlib import Path


def load_manifest(manifest_path: Path):
    if not manifest_path.exists():
        raise FileNotFoundError(f"Manifest not found: {manifest_path}")
    text = manifest_path.read_text(encoding="utf-8")
    data = yaml.safe_load(text)
    if not isinstance(data, dict):
        raise ValueError("Manifest root must be a mapping (expected keys like 'terms').")
    terms = data.get("terms")
    if not isinstance(terms, list):
        raise ValueError("Manifest must contain a 'terms' list.")
    return terms


def check_canonical_docs(repo_root: Path, terms):
    errors = []
    for term in terms:
        term_id = term.get("id") or term.get("name")
        canonical_doc = term.get("canonical_doc")
        if not canonical_doc:
            errors.append(f"term {term_id!r} is missing canonical_doc")
            continue
        target = (repo_root / canonical_doc).resolve()
        try:
            target.relative_to(repo_root)
        except ValueError:
            errors.append(
                f"term {term_id!r} canonical_doc path escapes repo root: {canonical_doc}"
            )
            continue
        if not target.exists():
            errors.append(
                f"term {term_id!r} canonical_doc does not exist: {canonical_doc}"
            )
    return errors


def find_unreferenced_policies(repo_root: Path, terms):
    """Return list of .md policy files under docs/agent/policies/ that are not referenced in the manifest."""
    policies_root = repo_root / "docs" / "agent" / "policies"
    all_md = {
        p.relative_to(repo_root)
        for p in policies_root.glob("*.md")
        if p.name not in {"INDEX.md", "agent-policy-manifest.md"}
    }

    referenced = set()
    for term in terms:
        canonical_doc = term.get("canonical_doc")
        if canonical_doc:
            referenced.add(Path(canonical_doc))

    unreferenced = sorted(str(p) for p in all_md - referenced)
    return unreferenced


def main():
    repo_root = Path(__file__).resolve().parent.parent
    manifest_path = repo_root / "docs" / "agent" / "policies" / "agent-policy-manifest.yaml"

    print(f"Using repo root: {repo_root}")
    print(f"Loading manifest: {manifest_path}")

    try:
        terms = load_manifest(manifest_path)
    except Exception as exc:  # noqa: BLE001
        print(f"[ERROR] Failed to load manifest: {exc}", file=sys.stderr)
        sys.exit(1)

    errors = check_canonical_docs(repo_root, terms)
    if errors:
        print("[ERROR] Policy manifest canonical_doc issues:")
        for msg in errors:
            print(f"  - {msg}")
        # Non-zero exit to signal structural problems
        sys.exit(1)

    unreferenced = find_unreferenced_policies(repo_root, terms)
    if unreferenced:
        print("[WARN] Unreferenced policy markdown files (not listed in manifest):")
        for path in unreferenced:
            print(f"  - {path}")
    else:
        print("[OK] All policy markdown files are referenced in the manifest.")

    print("[OK] Policy manifest structure validated.")


if __name__ == "__main__":
    main()