# Ansible Configuration for EC2 Instances

This directory contains Ansible playbooks and roles to configure EC2 instances created by Terraform.

## Directory Structure

```
ansible/
├── playbook.yml              # Main playbook
├── ansible.cfg               # Ansible configuration
├── generate-inventory.sh     # Script to generate inventory from Terraform
├── run-playbook.sh          # Script to run the playbook
├── roles/
│   ├── system-update/        # Role to update system packages
│   │   └── tasks/
│   │       └── main.yml
│   └── nginx/                # Role to install and configure Nginx
│       ├── tasks/
│       │   └── main.yml
│       ├── handlers/
│       │   └── main.yml
│       └── templates/
│           ├── nginx.conf.j2
│           └── index.html.j2
└── inventory/
    └── hosts.ini             # Ansible inventory (auto-generated)
```

## Prerequisites

1. **Ansible installed locally:**
   ```bash
   pip install ansible
   ```

2. **SSH access to EC2 instances** - Make sure your SSH key is properly configured

3. **EC2 instances created** with Terraform

## Usage

### Step 1: Generate Inventory from Terraform

The inventory is automatically generated from Terraform outputs:

```bash
cd ansible
bash generate-inventory.sh
```

This will create `inventory/hosts.ini` with your EC2 instance details from Terraform.

### Step 2: Run the Playbook

Execute the playbook to configure all EC2 instances:

```bash
bash run-playbook.sh
```

Or run Ansible playbook directly:

```bash
ansible-playbook -i inventory/hosts.ini playbook.yml
```

### Run Specific Roles or Tags

Run only the system update role:
```bash
ansible-playbook -i inventory/hosts.ini playbook.yml --tags system-update
```

Run only the Nginx installation:
```bash
ansible-playbook -i inventory/hosts.ini playbook.yml --tags nginx
```

## Playbook Details

The main playbook (`playbook.yml`) performs the following operations:

### 1. **System Update Role**
   - Updates apt cache
   - Upgrades all system packages
   - Installs required packages (curl, unzip, wget, git, vim)
   - Cleans up unused packages

### 2. **Nginx Role**
   - Installs Nginx web server
   - Deploys Nginx configuration
   - Creates web root directory
   - Deploys custom index.html with instance information
   - Enables and starts Nginx service
   - Verifies Nginx is running

### 3. **Post-Tasks**
   - Verifies Nginx is running
   - Tests HTTP connectivity
   - Displays deployment summary

## Roles

### system-update

Updates and upgrades the system packages. Can be run on all instances.

**Tasks:**
- Update apt cache
- Upgrade packages
- Install essential tools
- Remove unused packages

### nginx

Installs and configures Nginx web server with a custom homepage.

**Tasks:**
- Install Nginx
- Configure Nginx
- Deploy custom index.html
- Enable Nginx service

**Handlers:**
- Restart Nginx
- Reload Nginx configuration

## Variables

### Playbook Variables

- `nginx_version`: Nginx version to install (default: latest)
- `environment`: Environment name (production, staging, test)

### Role Variables

See individual role README files for role-specific variables.

## Customization

### Modify Nginx Configuration

Edit `roles/nginx/templates/nginx.conf.j2` to customize Nginx settings.

### Modify Index Page

Edit `roles/nginx/templates/index.html.j2` to customize the homepage.

### Add More Roles

Create new roles following the same structure:

```bash
ansible-galaxy init roles/my-role
```

Then include the role in `playbook.yml`.

## Troubleshooting

### Cannot reach hosts

1. Check if instances are running:
   ```bash
   aws ec2 describe-instances --region us-east-1
   ```

2. Verify SSH key permissions:
   ```bash
   chmod 400 ../key/MyEC2Key
   ```

3. Test SSH connectivity:
   ```bash
   ssh -i ../key/MyEC2Key ubuntu@<instance-dns>
   ```

### Playbook fails

1. Enable verbose output:
   ```bash
   ansible-playbook -i inventory/hosts.ini playbook.yml -vv
   ```

2. Check Ansible syntax:
   ```bash
   ansible-playbook -i inventory/hosts.ini playbook.yml --syntax-check
   ```

### SSH permission denied

1. Ensure you're using the correct SSH key
2. Verify the key file has correct permissions (400)
3. Make sure the security group allows SSH (port 22)

## Integration with Terraform

The Terraform module creates EC2 instances, and Ansible configures them after creation. The workflow is:

1. **Terraform** creates EC2 instances
2. **Ansible** connects to instances and configures them

The `generate-inventory.sh` script automatically extracts instance details from Terraform outputs.

## Next Steps

- Modify roles for your specific requirements
- Add more roles for additional services
- Implement configuration management
- Set up monitoring and logging
- Integrate with CI/CD pipeline

## References

- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
