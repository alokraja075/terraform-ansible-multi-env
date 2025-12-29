# Image Placeholder

To add the deployment output screenshot:

1. Take a screenshot of the Nginx webpage running at: http://ec2-44-204-246-218.compute-1.amazonaws.com
2. Save it as `image.png` in the root directory
3. The README will automatically display it

## Alternative: Create a simple diagram

You can also create a diagram showing:
- Browser accessing the EC2 instance
- Terraform provisioning the infrastructure
- Ansible configuring Nginx
- The beautiful gradient webpage with deployment info

## Current Output

The webpage shows:
- Title: "Terraform EC2 Instance"
- Message: "Nginx is running successfully!"
- Subtitle: "Deployed with Terraform and configured with Ansible"
- Beautiful gradient background (purple to blue)
- Responsive design

## Screenshot Command (if you have a screenshot tool)

```bash
# Using curl to save HTML
curl http://ec2-44-204-246-218.compute-1.amazonaws.com/ > output.html

# Or use browser developer tools to take a full-page screenshot
# Or use tools like:
# - Firefox: Right-click > Take Screenshot
# - Chrome: DevTools > Cmd+Shift+P > "Capture full size screenshot"
```

## Terraform Output Example

```
Outputs:

SSH_Key_Command = "ssh -i ./key/TestKP ubuntu@ec2-44-204-246-218.compute-1.amazonaws.com"
instance_id = "i-0be26bb0ec04e8b2c"
instance_public_dns = "ec2-44-204-246-218.compute-1.amazonaws.com"
instance_public_ip = "44.204.246.218"
ssh_key_path = "./key/TestKP"
web_urls = "ec2-44-204-246-218.compute-1.amazonaws.com"
```

## Ansible Playbook Output

```
PLAY [Configure EC2 instances with Ansible] *************************************

TASK [Upgrade Python to 3.9+] **************************************************
ok: [ec2-instance-1]

TASK [system-update : Update apt cache] ****************************************
ok: [ec2-instance-1]

TASK [system-update : Upgrade all packages] ************************************
ok: [ec2-instance-1]

TASK [nginx : Install Nginx package] *******************************************
ok: [ec2-instance-1]

TASK [nginx : Deploy custom index.html] ****************************************
ok: [ec2-instance-1]

TASK [nginx : Verify Nginx is running] *****************************************
ok: [ec2-instance-1]

PLAY RECAP **********************************************************************
ec2-instance-1             : ok=13   changed=0   unreachable=0   failed=0
```
