#!/bin/bash
# Script to create the arch-test VM for Ansible role testing
# Usage: ./vm-create.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Gnome Network - arch-test VM Creation        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}VM Name:${NC}  arch-test"
echo ""

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
terraform apply -auto-approve

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

echo ""
echo -e "${BLUE}═══ Next Step: Set Root Password ═══${NC}"
echo ""
echo "1. Open VM console:"
echo "   ${GREEN}virt-viewer --connect qemu:///system $VM_NAME${NC}"
echo ""
echo "2. At the login prompt, type: ${YELLOW}root${NC}"
echo ""
echo "3. Set password (match SSH_PASSWORD in .env):"
echo "   ${YELLOW}passwd${NC}"
echo ""
echo "That's it! SSH is already running."
echo ""

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  VM Ready for Ansible!                         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Run playbooks:${NC}"
echo "  cd .. && sudo -E docker compose exec ansible-dev \\"
echo "    ansible-playbook -i inventories/workstations/hosts.yml deploy.yml"
echo ""
echo -e "${YELLOW}To destroy this VM later:${NC}"
echo "  cd $SCRIPT_DIR && ./vm-destroy.sh"
echo ""