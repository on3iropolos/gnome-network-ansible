#!/usr/bin/env python3
"""Migrate .agent/ file-based memories to Hindsight."""
import glob
import os
import sys

try:
    from hindsight_client import Hindsight
except ImportError:
    print("Installing hindsight-client...")
    os.system("pip install hindsight-client")
    from hindsight_client import Hindsight

BANK_ID = "gnome-network-ansible"
API_URL = "http://localhost:8888"

client = Hindsight(base_url=API_URL)

def retain_file(filepath, context, doc_id=None, timestamp=None):
    """Retain a file's content into Hindsight."""
    with open(filepath, 'r') as f:
        content = f.read()
    kwargs = {"bank_id": BANK_ID, "content": content, "context": context}
    if doc_id:
        kwargs["document_id"] = doc_id
    if timestamp:
        kwargs["timestamp"] = timestamp
    result = client.retain(**kwargs)
    print(f"  Retained {filepath} -> {result.items_count} items")
    return result

print("Starting migration to Hindsight...")
print(f"  Bank: {BANK_ID}")
print(f"  API: {API_URL}\n")

# 1. Migrate MEMORY.md (long-term facts, no timestamp)
memory_path = ".agent/MEMORY.md"
if os.path.exists(memory_path):
    print("Migrating MEMORY.md...")
    retain_file(memory_path, "migration:memory", timestamp="unset")

# 2. Migrate recent change summaries
print("\nMigrating change summaries...")
summaries = sorted(glob.glob(".agent/changes_summary_*.md"))
for f in summaries[-5:]:  # Last 5
    print(f"  Processing {f}...")
    retain_file(f, "migration:changes", doc_id=f)

print("\nMigration complete!")
print(f"Visit http://localhost:9999 to verify memories in bank '{BANK_ID}'")
