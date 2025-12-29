#!/bin/bash

# Run Ansible playbook to configure EC2 instances

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "======================================"
echo "Configuring EC2 Instances with Ansible"
echo "======================================"

# Check if inventory exists
if [ ! -f "$SCRIPT_DIR/inventory/hosts.ini" ]; then
    echo "Generating inventory from Terraform outputs..."
    bash "$SCRIPT_DIR/generate-inventory.sh"
fi

# Check if instances are reachable
echo ""
echo "Checking connectivity to instances..."
ansible all -i "$SCRIPT_DIR/inventory/hosts.ini" -m ping

# Run the playbook
echo ""
echo "Running Ansible playbook..."
ansible-playbook -i "$SCRIPT_DIR/inventory/hosts.ini" "$SCRIPT_DIR/playbook.yml" -v

echo ""
echo "======================================"
echo "Configuration Complete!"
echo "======================================"
