#!/bin/bash
# Script to destroy the arch-test VM
# Usage: ./vm-destroy.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Gnome Network - arch-test VM Destruction     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

cd "$SCRIPT_DIR"

# Check if terraform state exists
if [ ! -f "terraform.tfstate" ]; then
    echo -e "${YELLOW}Warning: No terraform.tfstate found${NC}"
    echo "Terraform state not found. VM may already be destroyed or wasn't created with Terraform."
    echo ""
    echo -e "${YELLOW}Checking for arch-test VM manually:${NC}"
    virsh --connect qemu:///system list --all | grep "arch-test" || echo "  No arch-test VM found"
    exit 1
fi

# Show what will be destroyed
VM_NAME="arch-test"
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
terraform destroy -auto-approve

echo ""
echo -e "${GREEN}✓ VM destroyed successfully${NC}"
echo ""