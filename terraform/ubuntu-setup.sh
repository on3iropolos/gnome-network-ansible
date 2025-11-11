#!/bin/bash
# Ubuntu Setup Script for Terraform + libvirt VM Testing
# Run this once on a fresh Ubuntu system to configure the testing environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Gnome Network - Ubuntu Environment Setup     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running on Ubuntu
if ! grep -qi ubuntu /etc/os-release; then
    echo -e "${YELLOW}Warning: This script is designed for Ubuntu${NC}"
    echo -e "Continue anyway? (y/n)"
    read -r CONTINUE
    if [[ ! $CONTINUE =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Step 1: Install libvirt and KVM
echo -e "${YELLOW}→ Installing libvirt, KVM, and graphical tools...${NC}"
sudo apt-get update
sudo apt-get install -y \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    virt-manager \
    virt-viewer \
    apparmor-utils

# Step 2: Add user to required groups
echo -e "${YELLOW}→ Adding user to libvirt and kvm groups...${NC}"
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

echo -e "${GREEN}✓ User added to groups${NC}"
echo -e "${YELLOW}  Note: You'll need to log out and back in for group changes to take effect${NC}"

# Step 3: Configure libvirt
echo -e "${YELLOW}→ Configuring libvirt...${NC}"
sudo sed -i 's/^#user = "libvirt-qemu"/user = "libvirt-qemu"/' /etc/libvirt/qemu.conf
sudo sed -i 's/^#group = "kvm"/group = "kvm"/' /etc/libvirt/qemu.conf
sudo sed -i 's/^#dynamic_ownership = 1/dynamic_ownership = 1/' /etc/libvirt/qemu.conf

# Step 4: Disable AppArmor for libvirtd
echo -e "${YELLOW}→ Disabling AppArmor for libvirtd...${NC}"
sudo ln -sf /etc/apparmor.d/usr.sbin.libvirtd /etc/apparmor.d/disable/
sudo apparmor_parser -R /etc/apparmor.d/usr.sbin.libvirtd 2>/dev/null || true

# Step 5: Start and enable libvirtd
echo -e "${YELLOW}→ Starting libvirtd...${NC}"
sudo systemctl enable libvirtd
sudo systemctl restart libvirtd

# Step 6: Configure default network
echo -e "${YELLOW}→ Configuring default network...${NC}"
virsh --connect qemu:///system net-start default 2>/dev/null || true
virsh --connect qemu:///system net-autostart default

# Step 7: Install Terraform
echo -e "${YELLOW}→ Checking for Terraform...${NC}"
if ! command -v terraform &> /dev/null; then
    echo -e "${YELLOW}  Installing Terraform...${NC}"
    wget -O- https://apt.releases.hashicorp.com/gpg | \
        sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list
    
    sudo apt-get update && sudo apt-get install -y terraform
else
    echo -e "${GREEN}✓ Terraform already installed${NC}"
fi

# Step 8: Verify installation
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Verification                                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}Checking installations:${NC}"
terraform --version
virsh --connect qemu:///system version
echo ""

echo -e "${GREEN}User groups:${NC}"
groups | grep -E 'libvirt|kvm' && echo -e "${GREEN}✓ User in libvirt and kvm groups${NC}" || echo -e "${RED}✗ User NOT in groups - log out and back in${NC}"
echo ""

echo -e "${GREEN}libvirt status:${NC}"
sudo systemctl status libvirtd --no-pager | head -5
echo ""

echo -e "${GREEN}Default network:${NC}"
virsh --connect qemu:///system net-list | grep default
echo ""

echo -e "${GREEN}AppArmor status for libvirtd:${NC}"
sudo aa-status | grep libvirtd || echo "  (not confined - correct for testing)"
echo ""

# Final instructions
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Setup Complete!                               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "1. Log out and back in to apply group changes"
echo "2. cd terraform && ./vm-create.sh quick-test"
echo "3. Connect with: virt-viewer --connect qemu:///system arch-test-quick"
echo ""
echo -e "${YELLOW}To re-enable AppArmor for libvirtd later (if needed):${NC}"
echo "  sudo rm /etc/apparmor.d/disable/usr.sbin.libvirtd"
echo "  sudo apparmor_parser -a /etc/apparmor.d/usr.sbin.libvirtd"
echo "  sudo systemctl restart libvirtd"
echo ""