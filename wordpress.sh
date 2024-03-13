#!/bin/bash

# Prompt the user for details
read -p "Enter the domain name: " domain
read -p "Enter MySQL database name: " mysql_db
read -p "Enter MySQL username: " mysql_user
read -sp "Enter MySQL password: " mysql_pass
echo
read -p "Enter your email address for SSL certificate notifications: " email_address

# Define the Nginx virtual host file path
VHOST_FILE="/etc/nginx/sites-available/$domain"

# Use sudo to create and write to the Nginx virtual host file
sudo tee $VHOST_FILE <<EOF
server {
    listen 80;
    server_name $domain www.$domain;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    root /var/www/$domain;
    index index.php index.html index.htm;

    # Caching for Static Assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    # FastCGI Caching for PHP Files
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.2-fpm.sock; # Adjust PHP version as needed

        # FastCGI Cache Settings
        fastcgi_cache MYCACHE;
        fastcgi_cache_valid 200 60m;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Create the website root directory
sudo mkdir -p /var/www/$domain

# Set permissions for the website root directory
sudo chown -R www-data:www-data /var/www/$domain

# Enable the virtual host by creating a symbolic link
sudo ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/

# Reload Nginx to apply the changes
sudo systemctl reload nginx

# Install Certbot and obtain an SSL certificate
if [ -x "$(command -v apt)" ]; then
    sudo apt update
    sudo apt install -y certbot python3-certbot-nginx
elif [ -x "$(command -v yum)" ]; then
    sudo yum install -y epel-release
    sudo yum install -y certbot python3-certbot-nginx
fi

# Obtain SSL certificate
sudo certbot --nginx -d $domain --non-interactive --agree-tos -m $email_address --redirect

# Setup automatic renewal
echo "0 0,12 * * * root certbot renew --quiet" | sudo tee -a /etc/crontab > /dev/null

# Wait for 3 seconds before starting WordPress installation
sleep 3

# Download and install WordPress
cd /var/www/$domain
sudo wget https://wordpress.org/latest.tar.gz
sudo tar xzf latest.tar.gz --strip-components=1
sudo rm latest.tar.gz
sudo find /var/www/$domain -type d -exec chmod 750 {} \;
sudo find /var/www/$domain -type f -exec chmod 640 {} \;

# Automatically update wp-config.php with the database details
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/$mysql_db/g" wp-config.php
sudo sed -i "s/username_here/$mysql_user/g" wp-config.php
sudo sed -i "s/password_here/$mysql_pass/g" wp-config.php

# Wait for 1 second before restarting Nginx
sleep 1
sudo systemctl restart nginx

echo "Virtual host for $domain has been created, enabled, SSL certificate installed, and WordPress configured."
echo "Please visit https://$domain to complete the WordPress installation with your admin user and password."
