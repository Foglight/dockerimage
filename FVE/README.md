# FVE docker image deployment guide
---
## Overview
This is the deployment guide for Foglight for Virtualization(FVE) in docker containers. 
---
## Deploy with docker-compose
---
### Pre-Requisites
* Install docker-compose [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)
* Download [docker-compose.yml](https://github.com/Foglight/dockerimage/tree/master/FVE/docker-compose/docker-compose.yml)
### Deploy
* ``docker-compose up``
### Save your data to volume (optional)
* uncomment the following lines in docker-compose.yml before deploy   
```
#    volumes:   
#      - /var/lib/postgresql:/var/lib/postgresql/data   
```
---
## Deploy with docker command line
---
### Deploy
* Create network   
``docker network create --driver bridge fve-net``
* Deploy postgresql container   
``docker run --name postgresql --network fve-net -e POSTGRES_PASSWORD=foglight -d postgres:11.2``
* Deploy fve container   
``docker run --name fve --network fve-net -d -p 8080:8080 questfve/fve:latest``
* Deploy fglam container   
``docker run --name fglam --network fve-net -d questfve/fglam:latest``
### Save your data to volume (optional)
* add parameter ``-v /var/lib/postgresql:/var/lib/postgresql/data`` when deploy postgresql container
---
## Access FVE
Access with http://$DOCKER_HOST:8080, where $DOCKER_HOST is the hostname or IP of your docker host.
