#!/bin/bash

# Install Nginx
sudo apt upate
sudo apt install nginx -y
# Optionally check the status of Nginx
# sudo systemctl status nginx

# Wait for 2 seconds
sleep 2

# Configure Nginx with Gzip Compression and FastCGI Cache Settings
sudo sed -i '/http {/a \
    gzip on;\n\
    gzip_vary on;\n\
    gzip_proxied any;\n\
    gzip_comp_level 6;\n\
    gzip_buffers 16 8k;\n\
    gzip_http_version 1.1;\n\
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;\n\
    fastcgi_cache_path /etc/nginx/cache levels=1:2 keys_zone=MYCACHE:100m inactive=60m;\n\
    fastcgi_cache_key "$scheme$request_method$host$request_uri";' /etc/nginx/nginx.conf

# Test Nginx configuration and reload
sudo nginx -t
sudo systemctl reload nginx

# Wait for 2 seconds
sleep 2

# Install PHP 8.2
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install php8.2-cli php8.2 php8.2-fpm php8.2-mysql php8.2-xml php8.2-gd php8.2-curl php8.2-mbstring php8.2-redis -y
# Display PHP version (optional)
# php -v
sudo systemctl enable php8.2-fpm
sudo systemctl start php8.2-fpm

# Wait for 3 seconds
sleep 3

# Adjust PHP.ini settings
PHP_INI=$(php --ini | grep "Loaded Configuration File" | sed -e "s|.*:\s*||")
sudo sed -i -e 's/;opcache.enable=1/opcache.enable=1/' -e 's/;opcache.memory_consumption=128/opcache.memory_consumption=128/' -e 's/;opcache.interned_strings_buffer=8/opcache.interned_strings_buffer=8/' -e 's/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files=10000/' -e 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=2/' -e 's/;opcache.validate_timestamps=1/opcache.validate_timestamps=1/' -e 's/;session.cookie_httponly =/session.cookie_httponly = 1/' -e 's/;session.cookie_secure =/session.cookie_secure = 1/' -e 's/;max_execution_time = 30/max_execution_time = 120/' -e 's/;upload_max_filesize = 2M/upload_max_filesize = 64M/' -e 's/;post_max_size = 8M/post_max_size = 64M/' -e 's/;memory_limit = 128M/memory_limit = 256M/' "$PHP_INI"

# Install Redis
sudo apt install redis-server -y
sudo systemctl start redis-server
sudo systemctl enable redis-server
# Optionally check the status of Redis
# sudo systemctl status redis-server

# Configure Redis
sudo sed -i 's/^supervised no/supervised systemd/' /etc/redis/redis.conf
# Note: Adjusting maxmemory and maxmemory-policy settings should be done carefully to match your server's capacity

sudo systemctl restart redis-server

# Install PHP extension for Redis
sudo apt install php8.2-redis -y

# Restart Nginx to apply all changes
sudo systemctl restart nginx
