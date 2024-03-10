# chat_ai_system

1- install Portainer


sudo apt update
 
sudo apt install docker.io
 
docker volume create portainer_data
 
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

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
