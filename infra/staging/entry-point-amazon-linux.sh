#!/bin/bash

# Update package list and install Apache web server (httpd)
sudo yum update -y && sudo yum install -y httpd

# Start the Apache service
sudo systemctl start httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Write a message to the default web page (index.html)
echo "Github actions from glitch.stream now in action" | sudo tee /var/www/html/index.html > /dev/null


# Install Docker
sudo yum install -y docker

# Start Docker service
sudo systemctl start docker && sudo systemctl enable docker

# Add ec2-user to the docker group to allow non-root usage of Docker
sudo usermod -aG docker ec2-user

# (Optional) Force group membership update without logout
newgrp docker

# Run NGINX container on port 8080
docker run -d -p 8080:80 nginx
