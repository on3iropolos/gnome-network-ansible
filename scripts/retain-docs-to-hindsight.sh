#!/bin/bash
# Retain canonical docs from /docs into Hindsight
# Uses curl to call the Hindsight REST API directly.

set -e

BANK_ID="gnome-network-ansible"
API_URL="http://localhost:8888"

echo "Starting docs retention to Hindsight..."
echo "  Bank: $BANK_ID"
echo "  API: $API_URL"
echo ""

# Function to retain a file into Hindsight
retain_file() {
    local filepath="$1"
    local context="$2"
    local doc_id="$3"
    
    if [ ! -f "$filepath" ]; then
        echo "  Skipping (not found): $filepath"
        return
    fi
    
    echo "  Processing $filepath..."
    
    # Create JSON payload using python3
    python3 <<EOF
import json
import sys

filepath = "$filepath"
context = "$context"
doc_id = "$doc_id"

with open(filepath, 'r') as f:
    content = f.read()

if doc_id:
    payload = json.dumps({
        "items": [{
            "content": content,
            "context": context,
            "document_id": doc_id
        }]
    })
else:
    payload = json.dumps({
        "items": [{
            "content": content,
            "context": context
        }]
    })

# Write to temp file
with open('/tmp/hindsight_payload.json', 'w') as f:
    f.write(payload)
EOF
    
    # Call retain API
    response=$(curl -s -X POST "$API_URL/v1/default/banks/$BANK_ID/memories" \
        -H "Content-Type: application/json" \
        -d @/tmp/hindsight_payload.json)
    
    echo "    Result: $(echo "$response" | python3 -m json.tool 2>/dev/null | head -3)"
    echo ""
}

echo "=== Tier 1: Essential Knowledge (RETAIN) ==="
echo ""

# 1. Always Link Policy
retain_file "docs/agent/policies/always-link.md" "docs:policy" "docs/agent/policies/always-link.md"

# 2. General Instructions
retain_file "docs/agent/policies/general-instructions.md" "docs:policy" "docs/agent/policies/general-instructions.md"

# 3. Agent Operational Policies
retain_file "docs/agent/policies/agent-operational-policies.md" "docs:policy" "docs/agent/policies/agent-operational-policies.md"

# 4. Contributing Guide
retain_file "docs/contributing.md" "docs:contributing" "docs/contributing.md"

# 5. Testing Best Practices
retain_file "docs/reference/testing-best-practices.md" "docs:reference" "docs/reference/testing-best-practices.md"

# 6. Kubernetes Reference
retain_file "docs/kubernetes/reference.md" "docs:kubernetes" "docs/kubernetes/reference.md"

echo "=== Tier 2: Supporting Knowledge (RETAIN) ==="
echo ""

# 7. Mermaid Guidelines
retain_file "docs/architecture/mermaid-diagram-guidelines.md" "docs:architecture" "docs/architecture/mermaid-diagram-guidelines.md"

# 8. Log File Naming
retain_file "docs/policies/log-file-naming-and-location.md" "docs:policy" "docs/policies/log-file-naming-and-location.md"

# 9. Log Entry Format
retain_file "docs/policies/log-entry-format.md" "docs:policy" "docs/policies/log-entry-format.md"

# 10. Log Content Guidelines
retain_file "docs/policies/log-content-guidelines.md" "docs:policy" "docs/policies/log-content-guidelines.md"

# 11. Documenting Roles and Repository
retain_file "docs/how-to/documenting-roles-and-repository.md" "docs:how-to" "docs/how-to/documenting-roles-and-repository.md"

# 12. Troubleshooting Molecule
retain_file "docs/troubleshooting/troubleshooting-molecule.md" "docs:troubleshooting" "docs/troubleshooting/troubleshooting-molecule.md"

# 13. Kubernetes Getting Started
retain_file "docs/kubernetes/getting-started.md" "docs:kubernetes" "docs/kubernetes/getting-started.md"

echo "=== Retention Complete ==="
echo ""
echo "Visit http://localhost:9999 to verify memories in bank '$BANK_ID'"
echo ""
echo "NOTE: Skipped index/stub files (no enduring knowledge):"
echo "  - docs/agent/INDEX.md"
echo "  - docs/agent/commands/INDEX.md"
echo "  - docs/agent/policies/INDEX.md"
echo "  - docs/policies/INDEX.md"
echo "  - docs/agent/workflows/update-docs.md"
echo "  - Stubs: agent-logging.md, agent-workspace.md, working-directory.md"
