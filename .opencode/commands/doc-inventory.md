---
description: Scan and inventory all documentation in the repository. Outputs to .agent/tmp/inventory.yaml.
agent: build
---
Run the documentation inventory script:

```
python3 .opencode/scripts/inventory.py
```

Or use the command:
```
/doc-inventory
```

This scans all Markdown files and code comments, extracts documentation units with titles, snippets, and signatures, and writes the inventory to `.agent/tmp/inventory.yaml`.
