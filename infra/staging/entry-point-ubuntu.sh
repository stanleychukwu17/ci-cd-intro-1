#!/bin/bash
# this will work for ubuntu based images, but since i'm using the amazon linux image, it does not have the apt or apt-get, we have to use yum

# Update package list and install Apache web server (httpd)
sudo apt-get update && sudo apt-get install -y apache2

# Start the Apache service
sudo systemctl start apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Write a message to the default web page (index.html)
echo "Github actions from glitch.stream now in action" | sudo tee /var/www/html/index.html > /dev/null

#  install docker
sudo apt-get update && sudo apt-get install -y docker.io

# start docker
sudo systemctl docker start && sudo systemctl enable docker

# Add ec2-user to the docker group to allow non-root usage of Docker
sudo usermod -aG docker ec2-user

# (Optional) Force group membership update without logout
newgrp docker

# Run NGINX container on port 8080
docker run -d -p 8080:80 nginx

# If you want to stop the NGINX container later, you can use the command
# docker stop $(docker ps -q --filter ancestor=nginx)



# another option for installing the latest docker from the official docker repository
# This is the official Docker package and will provide the latest stable version of Docker.00
# If you want to ensure you are using the latest Docker features and updates, you should add Docker's official repository and install docker-ce (Community Edition).

# Update package list and install dependencies for Docker
# sudo apt-get update
# sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc

# Add Docker's official repository
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package list again to include Docker's repo
# sudo apt-get update

# Install Docker Community Edition (docker-ce)
# sudo apt-get install -y docker-ce
