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

### Access FVE
Access with http://$DOCKER_HOST:8080, where $DOCKER_HOST is the hostname or IP of your docker host.

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

### Access FVE
Access with http://$DOCKER_HOST:8080, where $DOCKER_HOST is the hostname or IP of your docker host.

## Deploy onto Kubernetes

### Deploy
* fve kubernetes deployment yaml file folder
``./kubernetes``
* prerequisite
  * kubernetes command line tool
[kubectl official installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
  * kubernetes configuration file (Kube Config)
It is a standard kubernetes file used for the kubectl client to access to the cluster. It could be retrieved from the master node on private cloud. And if on public cloud, different cloud have their guide to retrieve this file from the cluster.
* difference between load balancer and nodeport (with use cases)
  * load balancer: Public cloud kubernetes service. Private cloud with ingress controller. You will get a public IP address to access fve. [kubernetes ingress controller official guide](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).
  * node port: Public cloud which have a public node. Private cloud without ingress controller. You will check which node the fve container is running on and access to fve with http://$NODE_IP_ADDRESS:$EXPOSED_NODE_PORT
#### Deploy as Load Balancer
* fve kubernetes deployment yaml file
``./kubernetes/fve-loadbalancer.yml``
* Change ``loadBalancerIP: <Public IP>``
  * For AKS: follow the [official guide](https://docs.microsoft.com/en-us/azure/aks/static-ip).
#### Deploy as Node Port
* fve kubernetes deployment yaml file
``./kubernetes/fve-nodeport.yml``

### Access FVE
Access method will be different based on the different service deploy methods.
#### Load Balancer
* Use the public ip address ($PUBLIC_IP) in ``loadBalancerIP: <Public IP>`` and the port is 8080, http://$PUBLIC_IP:8080.
#### Node Port
* Check Access IP Address
  * ``kubectl describe pods -n questfve``, you should see a pod whose name is similar to "fve-app-54f44dc866-rv64x"
  * ``kubectl describe <pod name>``, find line similar to "Node:               kubeckaworker/10.2.122.15", and the "10.2.122.15" is the Node IP Address to access the fve ($NODE_IP_ADDRESS).
* Check Access Port
  * ``kubectl get svc fve -n questfve``, you should see the PORT(s) similar to "8080:32131/TCP", and the 32121 is the port exposed on the node with the previous IP address ($EXPOSED_NODE_PORT). 
* Access the fve service through http://$NODE_IP_ADDRESS:$EXPOSED_NODE_PORT.