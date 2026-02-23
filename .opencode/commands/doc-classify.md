---
description: Classify inventory units by subject/type/scope. Outputs to .agent/tmp/classified.yaml.
agent: build
---
Run the documentation classification script:

```
python3 .opencode/scripts/classify.py
```

Or use the command:
```
/doc-classify
```

This reads the inventory from `.agent/tmp/inventory.yaml`, classifies each unit by subject, type, and scope, detects duplicates, and writes to `.agent/tmp/classified.yaml`.

Run `/doc-inventory` first before running this command.
