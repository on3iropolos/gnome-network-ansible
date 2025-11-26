#!/usr/bin/env python3
"""
Run a documentation audit and write a machine-readable report.

- Scans README.md, AGENTS.md, and all docs/*.md files for Markdown links.
- Flags broken links, absolute paths, and links that escape the repository.
- Detects oversize docs (by word count) and duplicate concept signatures.
- Writes a JSON report to .agent/tmp/audit.json and docs/audit.json.

Usage:
  From the repository root:
    python .agent/doc_audit.py
"""

import json
import re
from pathlib import Path


RE_LINK = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")


def iter_markdown_links(path: Path):
    """Yield (line_no, link_text, href) for each markdown link in file."""
    text = path.read_text(encoding="utf-8")
    for idx, line in enumerate(text.splitlines(), start=1):
        for m in RE_LINK.finditer(line):
            yield idx, m.group(1), m.group(2)


def normalize_href(href: str):
    """Strip line suffix (:NNN) and hash fragment from a relative href."""
    # Ignore external links
    if href.startswith(("http://", "https://", "mailto:")):
        return None
    # Only handle relative links; absolute paths are considered invalid
    if href.startswith("/"):
        return href
    # Strip anchor
    if "#" in href:
        href, _ = href.split("#", 1)
    # Strip :line suffix used for clickable references
    if ":" in href:
        base, maybe_line = href.rsplit(":", 1)
        if maybe_line.isdigit():
            href = base
    return href


def collect_broken_links(repo_root: Path):
    broken = []
    docs_root = repo_root / "docs"
    entry_files = [repo_root / "README.md", repo_root / "AGENTS.md"]

    # Check all docs/ markdown files and entrypoints
    candidates = list(docs_root.rglob("*.md")) + entry_files
    for src in candidates:
        if not src.exists():
            continue
        base_dir = src.parent
        for line_no, text, href in iter_markdown_links(src):
            norm = normalize_href(href)
            if norm is None:
                continue
            # Absolute filesystem-like paths are considered invalid
            if norm.startswith("/"):
                broken.append({
                    "source": str(src.relative_to(repo_root)),
                    "line": line_no,
                    "href": href,
                    "reason": "absolute path not allowed",
                })
                continue
            target = (base_dir / norm).resolve()
            try:
                rel_target = target.relative_to(repo_root)
            except ValueError:
                # Link escapes the repo root
                broken.append({
                    "source": str(src.relative_to(repo_root)),
                    "line": line_no,
                    "href": href,
                    "reason": "link points outside repository",
                })
                continue
            if not target.exists():
                broken.append({
                    "source": str(src.relative_to(repo_root)),
                    "line": line_no,
                    "href": href,
                    "resolved_path": str(rel_target),
                    "reason": "target file does not exist",
                })
    return broken


def collect_oversize_docs(repo_root: Path, word_limit: int = 800):
    docs_root = repo_root / "docs"
    oversize = []
    for md in docs_root.rglob("*.md"):
        text = md.read_text(encoding="utf-8")
        words = re.findall(r"\w+", text)
        if len(words) > word_limit:
            oversize.append({
                "path": str(md.relative_to(repo_root)),
                "word_count": len(words),
                "limit": word_limit,
            })
    return oversize


def collect_duplicates(repo_root: Path):
    classified = repo_root / ".agent" / "tmp" / "classified.yaml"
    if not classified.exists():
        return []
    duplicates = []
    current = None
    for line in classified.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped.startswith("- signature:"):
            # Start new duplicate record
            parts = stripped.split('"')
            if len(parts) >= 2:
                sig = parts[1]
            else:
                continue
            current = {"signature": sig, "canonical_id": None, "duplicate_ids": []}
            duplicates.append(current)
        elif current is not None and stripped.startswith("canonical_id:"):
            parts = stripped.split('"')
            if len(parts) >= 2:
                current["canonical_id"] = parts[1]
        elif current is not None and stripped.startswith("- ") and not stripped.startswith("- signature:"):
            # duplicate_ids list items
            if '"' in stripped:
                parts = stripped.split('"')
                if len(parts) >= 2:
                    dup_id = parts[1]
                    current["duplicate_ids"].append(dup_id)
    return duplicates


def main():
    repo_root = Path(__file__).resolve().parent.parent
    # Ephemeral path for agent workflows
    audit_tmp_path = repo_root / ".agent" / "tmp" / "audit.json"
    # Canonical machine-readable audit report under docs/
    docs_audit_path = repo_root / "docs" / "audit.json"

    broken_links = collect_broken_links(repo_root)
    oversize_docs = collect_oversize_docs(repo_root)
    duplicates = collect_duplicates(repo_root)

    report = {
        "broken_links": broken_links,
        "oversize_docs": oversize_docs,
        "duplicates": duplicates,
    }

    json_report = json.dumps(report, indent=2, sort_keys=True) + "\n"
    audit_tmp_path.write_text(json_report, encoding="utf-8")
    docs_audit_path.write_text(json_report, encoding="utf-8")
    print(f"Wrote audit report to {audit_tmp_path} and {docs_audit_path}")


if __name__ == "__main__":
    main()