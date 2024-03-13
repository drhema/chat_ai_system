#!/bin/bash

# Install Nginx
sudo apt upate
sudo apt install nginx -y
# Optionally check the status of Nginx
# sudo systemctl status nginx

# Wait for 2 seconds
sleep 2

# Configure Nginx with Gzip Compression and FastCGI Cache Settings
# Uncomment default gzip settings in Nginx configuration
sudo sed -i 's/# gzip_vary on;/gzip_vary on;/' /etc/nginx/nginx.conf
sudo sed -i 's/# gzip_proxied any;/gzip_proxied any;/' /etc/nginx/nginx.conf
sudo sed -i 's/# gzip_comp_level 6;/gzip_comp_level 6;/' /etc/nginx/nginx.conf
sudo sed -i 's/# gzip_buffers 16 8k;/gzip_buffers 16 8k;/' /etc/nginx/nginx.conf
sudo sed -i 's/# gzip_http_version 1.1;/gzip_http_version 1.1;/' /etc/nginx/nginx.conf
sudo sed -i 's/# gzip_types text\/plain text\/css application\/json application\/javascript text\/xml application\/xml application\/xml\+rss text\/javascript;/gzip_types text\/plain text\/css application\/json application\/javascript text\/xml application\/xml application\/xml\+rss text\/javascript;/' /etc/nginx/nginx.conf

# Append FastCGI cache settings to nginx.conf
echo 'fastcgi_cache_path /etc/nginx/cache levels=1:2 keys_zone=MYCACHE:100m inactive=60m;' | sudo tee -a /etc/nginx/nginx.conf
echo 'fastcgi_cache_key "$scheme$request_method$host$request_uri";' | sudo tee -a /etc/nginx/nginx.conf

# Test Nginx configuration and reload
sudo nginx -t
sudo systemctl reload nginx

# Wait for 2 seconds
sleep 2

# Install PHP 8.2
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get install libhtml-parser-perl -y
sudo apt update
sudo apt install php8.2-cli php8.2 php8.2-fpm php8.2-mysql php8.2-xml php8.2-gd php8.2-curl php8.2-mbstring php8.2-redis -y
# Display PHP version (optional)
# php -v
sudo systemctl enable php8.2-fpm
sudo systemctl start php8.2-fpm

# Wait for 3 seconds
sleep 3

# Define the PHP.ini path directly
PHP_INI="/etc/php/8.2/fpm/php.ini"

# Adjust PHP.ini settings explicitly
sudo sed -i 's/;opcache.enable=1/opcache.enable=1/' $PHP_INI
sudo sed -i 's/;opcache.memory_consumption=128/opcache.memory_consumption=128/' $PHP_INI
sudo sed -i 's/;opcache.interned_strings_buffer=8/opcache.interned_strings_buffer=8/' $PHP_INI
sudo sed -i 's/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files=10000/' $PHP_INI
sudo sed -i 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=2/' $PHP_INI
sudo sed -i 's/;opcache.validate_timestamps=1/opcache.validate_timestamps=1/' $PHP_INI
sudo sed -i 's/;session.cookie_httponly =/session.cookie_httponly = 1/' $PHP_INI
sudo sed -i 's/;session.cookie_secure =/session.cookie_secure = 1/' $PHP_INI
sudo sed -i 's/;max_execution_time = 30/max_execution_time = 120/' $PHP_INI
sudo sed -i 's/;upload_max_filesize = 2M/upload_max_filesize = 64M/' $PHP_INI
sudo sed -i 's/;post_max_size = 8M/post_max_size = 64M/' $PHP_INI
sudo sed -i 's/;memory_limit = 128M/memory_limit = 256M/' $PHP_INI

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
