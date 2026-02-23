---
description: Audit docs for broken links, oversize files, and duplicates. Writes to .agent/tmp/audit.json.
agent: build
---
Run the documentation audit script:

```
python3 .opencode/scripts/audit.py
```

Or use the command:
```
/doc-audit
```

This scans all documentation for:
- Broken or invalid links
- Oversize docs (>800 words)
- Duplicate concept signatures

Writes the audit report to `.agent/tmp/audit.json` and `docs/audit.json`.
