#!/usr/bin/env python3
"""Retain canonical docs from /docs into Hindsight."""
import json
import os
import urllib.request

BANK_ID = "gnome-network-ansible"
API_URL = "http://localhost:8888"

# Tier 1 + Tier 2 docs to retain
DOCS = [
    # Tier 1: Essential Knowledge
    ("docs/agent/policies/always-link.md", "docs:policy", "docs/agent/policies/always-link.md"),
    ("docs/agent/policies/general-instructions.md", "docs:policy", "docs/agent/policies/general-instructions.md"),
    ("docs/agent/policies/agent-operational-policies.md", "docs:policy", "docs/agent/policies/agent-operational-policies.md"),
    ("docs/contributing.md", "docs:contributing", "docs/contributing.md"),
    ("docs/reference/testing-best-practices.md", "docs:reference", "docs/reference/testing-best-practices.md"),
    ("docs/kubernetes/reference.md", "docs:kubernetes", "docs/kubernetes/reference.md"),
    # Tier 2: Supporting Knowledge
    ("docs/architecture/mermaid-diagram-guidelines.md", "docs:architecture", "docs/architecture/mermaid-diagram-guidelines.md"),
    ("docs/policies/log-file-naming-and-location.md", "docs:policy", "docs/policies/log-file-naming-and-location.md"),
    ("docs/policies/log-entry-format.md", "docs:policy", "docs/policies/log-entry-format.md"),
    ("docs/policies/log-content-guidelines.md", "docs:policy", "docs/policies/log-content-guidelines.md"),
    ("docs/how-to/documenting-roles-and-repository.md", "docs:how-to", "docs/how-to/documenting-roles-and-repository.md"),
    ("docs/troubleshooting/troubleshooting-molecule.md", "docs:troubleshooting", "docs/troubleshooting/troubleshooting-molecule.md"),
    ("docs/kubernetes/getting-started.md", "docs:kubernetes", "docs/kubernetes/getting-started.md"),
]

def retain_file(filepath, context, doc_id=None):
    """Retain a file into Hindsight using urllib."""
    if not os.path.exists(filepath):
        print(f"  Skipping (not found): {filepath}")
        return
    
    print(f"  Processing {filepath}...")
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    item = {"content": content, "context": context}
    if doc_id:
        item["document_id"] = doc_id
    
    payload = json.dumps({"items": [item]}).encode('utf-8')
    
    req = urllib.request.Request(
        f"{API_URL}/v1/default/banks/{BANK_ID}/memories",
        data=payload,
        headers={'Content-Type': 'application/json'},
        method='POST'
    )
    
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            result = json.loads(resp.read().decode('utf-8'))
            items = result.get('items_count', 0)
            print(f"    -> {items} items retained")
    except Exception as e:
        print(f"    -> Error: {e}")

print("Starting docs retention to Hindsight...")
print(f"  Bank: {BANK_ID}")
print(f"  API: {API_URL}")
print()
print("=== Tier 1: Essential Knowledge ===")
for filepath, context, doc_id in DOCS[:6]:
    retain_file(filepath, context, doc_id)

print()
print("=== Tier 2: Supporting Knowledge ===")
for filepath, context, doc_id in DOCS[6:]:
    retain_file(filepath, context, doc_id)

print()
print("=== Retention Complete ===")
print(f"Visit http://localhost:9999 to verify memories in bank '{BANK_ID}'")
print()
print("NOTE: Skipped index/stub files (no enduring knowledge)")
