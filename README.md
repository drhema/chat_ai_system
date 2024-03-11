# chat_ai_system

1- install Portainer & webmin

wget https://raw.githubusercontent.com/drhema/chat_ai_system/main/portainer.sh&& chmod +x portainer.sh && ./portainer.sh


2- nginx, php, redis cache for wordpress

wget https://raw.githubusercontent.com/drhema/chat_ai_system/main/nginx-php-redis.sh&& chmod +x nginx-php-redis.sh && ./nginx-php-redis.sh

Note redis cache is against redis memory as they run on same port

for mongodb 
docker network create mi_red
docker volume create mongodb_data
docker volume create mongodb_configdb_data

 
then access
https://IP-ADDRESS:9443
HFV@qwe



2- create mongodb stack



add this to web editor

https://github.com/drhema/chat_ai_system/blob/main/mogodb.yml
