#!/bin/bash

# Update and upgrade the system packages
sudo apt update && sudo apt upgrade -y

# Add the Webmin repository
echo "deb http://download.webmin.com/download/repository sarge contrib" | sudo tee -a /etc/apt/sources.list

# Import the Webmin GPG key
wget -qO - http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
sudo ufw allow 10000/tcp
# Update the package lists
sudo apt update

# Install Webmin
sudo apt install webmin -y

# Wait for 3 seconds
sleep 3

# Install Docker
sudo apt update
sudo apt install docker.io -y

# Create a Docker volume for Portainer
docker volume create portainer_data

# Run the Portainer container
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Wait for 5 seconds
sleep 5

# Fetch the server's current IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Display the success message with URLs
echo "Installation is complete. You can access the services using the following URLs:"
echo "Webmin: https://${SERVER_IP}:10000"
echo "Portainer: https://${SERVER_IP}:9443"
