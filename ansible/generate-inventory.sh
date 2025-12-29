#!/bin/bash

# This script generates the Ansible inventory from Terraform outputs

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Generating Ansible inventory from Terraform outputs..."
echo "Project root: $PROJECT_ROOT"

# Get the EC2 instance public DNS from Terraform
INSTANCE_DNS=$(cd "$PROJECT_ROOT" && terraform output -raw instance_public_dns 2>/dev/null || echo "")

if [ -z "$INSTANCE_DNS" ]; then
    echo "Error: Could not retrieve instance DNS from Terraform outputs"
    echo "Make sure Terraform has applied your configuration first"
    exit 1
fi

# Generate inventory file
cat > "$SCRIPT_DIR/inventory/hosts.ini" << EOF
[ec2_instances]
ec2-instance-1 ansible_host=$INSTANCE_DNS

[ec2_instances:vars]
ansible_user=ubuntu
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file=../key/TestKP
EOF

echo "✓ Inventory generated successfully!"
echo "  Instance: $INSTANCE_DNS"
echo "  Location: $SCRIPT_DIR/inventory/hosts.ini"
