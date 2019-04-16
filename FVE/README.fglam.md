# FGLAM docker image deployment guide   
## Overview   
This is the deployment guide for Foglight Agent Manager in docker containers.    

## Deploy with docker command line   

### Deploy   
```
docker run --name fglam -e FMS_URL=http://$FMS_URL -e FGLAM_AUTH_TOKEN=$FGLAM_AUTH_TOKEN -d questfve/fglam:latest
```   

### Notes
* $FMS_URL is the url of your FMS server, if your FMS is deployed with the [FVE docker image](https://cloud.docker.com/repository/docker/questfve/fve), you don't need to sepecify the -e ``FMS_URL=http://$FMS_URL`` in the command, but you need to make sure http://fve:8080 is accessible by the fglam container   
* $FGLAM_AUTH_TOKEN is the token use to authenticate this fglam on the FMS server, if your FMS is deployed with the [FVE docker image](https://cloud.docker.com/repository/docker/questfve/fve), you don't need to sepecify the -e ``-e FGLAM_AUTH_TOKEN=$FGLAM_AUTH_TOKEN`` in the command   
* if your FMS is not deployed with the FVE docker image, you will need to generate the token on your FMS server, to generate an auth token:   
** Access FMS MBean console: ${FMS_URL}:8080/jmx-console/   
** Go to FglAM -> name=TokenManager -> generateAuthToken(), Invoke it with no parameter setting.   
