#!/bin/bash
# Script to create a test VM for Ansible role testing
# Usage: ./vm-create.sh [scenario] [test_id]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
SCENARIO="${1:-quick-test}"
TEST_ID="${2:-test-$(date +%s)}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Gnome Network - VM Creation                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Scenario:${NC} $SCENARIO"
echo -e "${GREEN}Test ID:${NC}  $TEST_ID"
echo ""

# Check if scenario file exists
SCENARIO_FILE="$SCRIPT_DIR/scenarios/${SCENARIO}.tfvars"
if [ ! -f "$SCENARIO_FILE" ]; then
    echo -e "${RED}Error: Scenario file not found: $SCENARIO_FILE${NC}"
    echo ""
    echo "Available scenarios:"
    ls -1 "$SCRIPT_DIR/scenarios/"*.tfvars 2>/dev/null | xargs -n1 basename | sed 's/.tfvars$//' || echo "  (none found)"
    exit 1
fi

# Check prerequisites
echo -e "${YELLOW}→ Checking prerequisites...${NC}"
command -v terraform >/dev/null 2>&1 || {
    echo -e "${RED}Error: terraform is not installed${NC}"
    echo "Install: https://www.terraform.io/downloads"
    exit 1
}

command -v virt-viewer >/dev/null 2>&1 || {
    echo -e "${YELLOW}Warning: virt-viewer is not installed${NC}"
    echo "Install: sudo apt-get install virt-viewer"
    echo "You won't be able to open GUI automatically."
}

# Initialize Terraform
echo -e "${YELLOW}→ Initializing Terraform...${NC}"
cd "$SCRIPT_DIR"
terraform init -upgrade

# Apply configuration
echo -e "${YELLOW}→ Creating VM...${NC}"
terraform apply \
    -var="test_id=$TEST_ID" \
    -var-file="$SCENARIO_FILE" \
    -auto-approve

# Get outputs
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  VM Created Successfully!                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

VM_NAME=$(terraform output -raw vm_name)
VM_IP=$(terraform output -raw vm_ip 2>/dev/null || echo "Waiting for DHCP...")
INSTALL_DISK=$(terraform output -raw install_disk)

echo -e "${GREEN}VM Name:${NC}        $VM_NAME"
echo -e "${GREEN}VM IP:${NC}          $VM_IP"
echo -e "${GREEN}Install Disk:${NC}   $INSTALL_DISK"
echo ""

# Show connection commands
echo -e "${BLUE}═══ Connection Commands ═══${NC}"
echo ""
echo -e "${GREEN}1. Open GUI (virt-viewer):${NC}"
echo "   virt-viewer --connect qemu:///system $VM_NAME"
echo ""
echo -e "${GREEN}2. Or use virt-manager:${NC}"
echo "   virt-manager"
echo "   (Then find '$VM_NAME' in the list)"
echo ""
echo -e "${GREEN}3. SSH (after VM boots and you configure it):${NC}"
echo "   ssh root@$VM_IP"
echo ""

# Offer to open GUI
if command -v virt-viewer >/dev/null 2>&1; then
    echo -e "${YELLOW}Open graphical console now? (y/n)${NC}"
    read -r -n 1 OPEN_GUI
    echo ""
    if [[ $OPEN_GUI =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}→ Opening virt-viewer...${NC}"
        virt-viewer --connect qemu:///system "$VM_NAME" &
        echo ""
        echo -e "${GREEN}Graphical console opened in background${NC}"
    fi
fi

echo ""
echo -e "${BLUE}═══ Next Steps ═══${NC}"
echo ""
echo "1. The VM will boot from the Arch ISO"
echo "2. In the VM console:"
echo "   - Set root password: passwd"
echo "   - Start SSH: systemctl start sshd"
echo "   - Check IP: ip a"
echo ""
echo "3. Run Ansible playbooks against this VM"
echo "   (Update your inventory with the VM IP)"
echo ""
echo -e "${YELLOW}To destroy this VM later, run:${NC}"
echo "   cd $SCRIPT_DIR && ./vm-destroy.sh $TEST_ID"
echo ""