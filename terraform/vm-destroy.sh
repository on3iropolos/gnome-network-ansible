#!/bin/bash
# Script to destroy a test VM created for Ansible role testing
# Usage: ./vm-destroy.sh [test_id]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get test_id parameter
TEST_ID="${1}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Gnome Network - VM Destruction               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Check if test_id provided
if [ -z "$TEST_ID" ]; then
    echo -e "${RED}Error: No test_id provided${NC}"
    echo ""
    echo "Usage: $0 <test_id>"
    echo ""
    echo "To destroy VM, you need to provide the test_id used during creation."
    echo ""
    echo -e "${YELLOW}Active VMs:${NC}"
    virsh --connect qemu:///system list --all | grep "arch-test-" || echo "  (none found)"
    echo ""
    exit 1
fi

cd "$SCRIPT_DIR"

# Check if terraform state exists
if [ ! -f "terraform.tfstate" ]; then
    echo -e "${YELLOW}Warning: No terraform.tfstate found${NC}"
    echo "Terraform state not found. VM may already be destroyed or wasn't created with Terraform."
    echo ""
    echo -e "${YELLOW}Attempting to list VMs manually:${NC}"
    virsh --connect qemu:///system list --all | grep "arch-test-$TEST_ID" || echo "  No matching VMs found"
    exit 1
fi

# Show what will be destroyed
VM_NAME="arch-test-$TEST_ID"
echo -e "${YELLOW}Will destroy:${NC} $VM_NAME"
echo ""

# Confirm destruction
echo -e "${RED}Are you sure you want to destroy this VM? (yes/no)${NC}"
read -r CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo -e "${YELLOW}Aborted.${NC}"
    exit 0
fi

# Destroy VM
echo ""
echo -e "${YELLOW}→ Destroying VM with Terraform...${NC}"
terraform destroy -var="test_id=$TEST_ID" -auto-approve

echo ""
echo -e "${GREEN}✓ VM destroyed successfully${NC}"
echo ""

# Check if any VMs are still running
REMAINING=$(virsh --connect qemu:///system list --all | grep "arch-test-" | wc -l || echo "0")
if [ "$REMAINING" -gt 0 ]; then
    echo -e "${BLUE}Remaining test VMs:${NC}"
    virsh --connect qemu:///system list --all | grep "arch-test-" || true
    echo ""
fi