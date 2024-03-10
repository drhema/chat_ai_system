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

```yaml
version: "3.7"

services:
  mongodb:
    image: mongo:7
    command: mongod --port 27017
    networks:
      - mi_red
    volumes:
      - mongodb_data:/data/db
      - mongodb_configdb_data:/data/configdb
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=HFVHIDL12
      - PUID=1000
      - PGID=1000
    ports:
      - 27017:27017

volumes:
  mongodb_data:
    external: true
    name: mongodb_data
  mongodb_configdb_data:
    external: true
    name: mongodb_configdb_data

networks:
  mi_red:
    external: true
    name: mi_red

