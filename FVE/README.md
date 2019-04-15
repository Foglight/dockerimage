# FVE docker image deployment guide
## Overview   
This is the deployment guide for Foglight for Virtualization(FVE) in docker containers. You can either deploy with docker-compose or docker command line. Deploy with docker-compose is recommended by FVE team.

## Deploy with docker-compose (recommended)   

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

### Deploy additional fglam containers (optional)  
Add following lines to docker-compose.yml and deploy, note that $N represents number as postfix to your additional fglam, you can change it to any number or using your own naming conversions
```
  fglam_$N:
    image: questfve/fglam:latest
    networks:
      - fve-net
``` 

## Deploy with docker command line   

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

### Deploy additional fglam containers (optional)  
Run following commands, note that $N represents number as postfix to your additional fglam, you can change it to any number or using your own naming conversions
```
docker run --name fglam_$N --network fve-net -d questfve/fglam:latest
``` 

## Access FVE
Access with http://$DOCKER_HOST:8080, where $DOCKER_HOST is the hostname or IP of your docker host.
