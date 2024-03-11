
# Chat AI System

This repository contains scripts and configurations to set up a Chat AI system with Portainer, Webmin, Nginx, PHP, Redis Cache for WordPress, and MongoDB. Follow the instructions below to get started.

## 1. Install Portainer & Webmin

To install Portainer and Webmin, run the following commands:

```bash
wget https://raw.githubusercontent.com/drhema/chat_ai_system/main/portainer.sh && chmod +x portainer.sh && ./portainer.sh
```

## 2. Nginx, PHP, Redis Cache for WordPress

To set up Nginx, PHP, and Redis Cache for WordPress, execute:

```bash
wget https://raw.githubusercontent.com/drhema/chat_ai_system/main/nginx-php-redis.sh && chmod +x nginx-php-redis.sh && ./nginx-php-redis.sh
```

**Note:** Redis cache is against Redis memory as they run on the same port.

### MongoDB Setup

First, create a Docker network and volumes for MongoDB:

```bash
docker network create mi_red
docker volume create mongodb_data
docker volume create mongodb_configdb_data
```

## Accessing the Services

- **Portainer:** https://IP-ADDRESS:9443 with password `HFV@qwe`

## Create MongoDB Stack

Add the content from the following URL to the web editor in Portainer:

[https://github.com/drhema/chat_ai_system/blob/main/mogodb.yml](https://github.com/drhema/chat_ai_system/blob/main/mogodb.yml)
```
