#!/bin/bash
# Migrate .agent/ file-based memories to Hindsight
# Uses curl to call the Hindsight REST API directly

set -e

BANK_ID="gnome-network-ansible"
API_URL="http://localhost:8888"
AGENT_DIR=".agent.archived"

echo "Starting migration to Hindsight..."
echo "  Bank: $BANK_ID"
echo "  API: $API_URL"
echo ""

# Function to retain a file
retain_file() {
    local filepath="$1"
    local context="$2"
    local doc_id="${3:-}"
    local timestamp="${4:-}"
    
    if [ ! -f "$filepath" ]; then
        echo "  Skipping (not found): $filepath"
        return
    fi
    
    echo "  Processing $filepath..."
    
    # Read file content, escape JSON strings
    local content
    content=$(jq -Rs . "$filepath" 2>/dev/null || python3 -c "import sys,json; print(json.dumps(sys.stdin.read()))" < "$filepath")
    
    # Build JSON payload
    local payload
    if [ -n "$doc_id" ]; then
        payload=$(jq -n \
            --arg context "$context" \
            --arg content "$content" \
            --arg doc_id "$doc_id" \
            '{items: [{content: $content, context: $context, document_id: $doc_id}]}')
    else
        payload=$(jq -n \
            --arg context "$context" \
            --arg content "$content" \
            '{items: [{content: $content, context: $context}]}')
    fi
    
    # Call retain API
    local response
    response=$(curl -s -X POST "$API_URL/v1/default/banks/$BANK_ID/memories" \
        -H "Content-Type: application/json" \
        -d "$payload")
    
    echo "    Response: $response" | head -c 200
    echo ""
}

# 1. Migrate MEMORY.md (long-term facts, no timestamp)
if [ -f "$AGENT_DIR/MEMORY.md" ]; then
    echo "Migrating MEMORY.md..."
    retain_file "$AGENT_DIR/MEMORY.md" "migration:memory"
fi

# 2. Migrate NOW.md if exists
if [ -f "$AGENT_DIR/NOW.md" ]; then
    echo "Migrating NOW.md..."
    retain_file "$AGENT_DIR/NOW.md" "migration:now"
fi

# 3. Migrate recent change summaries (last 5)
echo ""
echo "Migrating change summaries..."
shopt -s nullglob
summaries=( "$AGENT_DIR"/changes_summary_*.md )
# Sort by filename (which includes date)
IFS=$'\n' sorted=($(sort <<<"${summaries[*]}"))
unset IFS

count=0
for f in "${sorted[@]}"; do
    count=$((count + 1))
    # Only migrate last 5
    if [ $count -gt $((${#sorted[@]} - 5)) ]; then
        retain_file "$f" "migration:changes" "$f"
    fi
done

echo ""
echo "Migration complete!"
echo "Visit http://localhost:9999 to verify memories in bank '$BANK_ID'"
