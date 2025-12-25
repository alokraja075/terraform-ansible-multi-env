#!/bin/bash

# Exit immediately if a command fails
set -x

# Log output for debugging
exec > /var/log/user-data.log 2>&1

echo "===== User data script started ====="

# Update package list
apt-get update -y

# Upgrade existing packages
apt-get upgrade -y

# Install required packages
apt-get install -y nginx curl unzip

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx

# Create a simple web page
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Terraform EC2</title>
</head>
<body>
    <h1>Hello from Terraform - Test</h1>
    <p>Nginx installed using Terraform</p>
</body>
</html>
EOF

# Restart Nginx to apply changes
systemctl restart nginx

echo "===== User data script completed ====="
