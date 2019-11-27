# Build and run the FglAM Docker Image
This document is the guide about how to build and run the FglAM Docker Image.

## FglAM image building guide
Here are the steps about how to build your own FglAM Docker Image:
* Download the following 4 files and put them in the same folder \
[Dockerfile](https://github.com/Foglight/dockerimage/blob/master/FglAMDockerImage/Dockerfile),  [installer.properties](https://github.com/Foglight/dockerimage/blob/master/FglAMDockerImage/installer.properties),  [docker-entrypoint.sh](https://github.com/Foglight/dockerimage/blob/master/FglAMDockerImage/docker-entrypoint.sh), FglAM-{version}-linux-x86_64.bin \
\
For the first three files, you can download them from this github; For the FglAM-{version}-linux-x86_64.bin, you can check the download instruction in "Additional Information" section at the end of the document.
* Edit the [Dockerfile](https://github.com/Foglight/dockerimage/blob/master/FglAMDockerImage/Dockerfile) \
Replace all the "FglAM-{version}-linux-x86_64.bin" strings(at line 8 and 10) with the specific FglAM installer file name you downloaded at first step.
* Edit the [docker-entrypoint.sh](https://github.com/Foglight/dockerimage/blob/master/FglAMDockerImage/docker-entrypoint.sh) \
Replace the "FglAM-{version}-linux-x86_64.bin" string(at line 13) with the specific FglAM installer file name you downloaded at first step.
* cd to the folder where the [Dockerfile](https://github.com/Foglight/dockerimage/blob/master/FglAMDockerImage/Dockerfile) locates, and execute below command to build the FglAM image: 

#### Build command
```
docker build -t ${IMAGE_NAME}:tag .
```
#### Example
```
docker build -t fglamimg:latest .
```

## FglAM image deployment guide
After building the FglAM image, you can run below command to deploy FglAM image as a docker container.

#### Deploy command
```
docker run -dit --name ${CONTAINER_NAME} -e FMS_URL=${FMS_URL} -e HOST_DISPLAY_NAME=${HOST_DISPLAY_NAME} -e AUTH_TOKEN=${AUTH_TOKEN} ${IMAGE_NAME}:latest
```
#### Example 
```
docker run -dit --name dockerfglam -e FMS_URL=10.154.14.14 -e HOST_DISPLAY_NAME=DockerFglAMTest -e AUTH_TOKEN=encrypted:be054a065b65b7947054a21453fa64d570df441e46c49ab073039a48c893a392da5b289af8925d864d4e9831ba21fc3ad0383cae86be2b5fc3783a329bfdd1dc1a04c86c557b21596def6ceeffd97bfdb58afbed5dbf31bba6c3d62c31758ebcf0d8941b6a317b41b93f72c4d18c2919 fglamimg:latest
```
Note: For how to retrieve the AUTH_TOKEN, please check the installer.properties instruction in the "Additional Information" section for details.

# Additional Information
This section is mainly about the detail instructions of the role and usage of the files that we use to build the FglAM image.
## Dockerfile:
Below is the main workflow/steps about how the FglAM docker file work: 
- Pull the ubuntu image
- Update the apt lib. 
- Define the WORKDIR. 
- Copy the FglAM installer and properties file to the WORKDIR and install it using HTTPS connection to FMS. 
- Execute the docker-entrypoint script to install FglAM and start it up. 


## docker-entrypoint.sh:
This script will execute while running the fglam image to the container. If setting the -e FMS_URL, HOST_DISPLAY_NAME, AUTH_TOKEN parameters to the installer.properties file, it will start to install the FglAM instance and start it up automatically.  


## installer.properties:
This file is used to set different properties during the FglAM installation, and here are the properties instructions.
* installer.installdir=/opt/fglam \
Set the directory to which FoglightAgentManager will be installed. 

* installer.fms=url=https://${FMS_URL}:8443,ssl-allow-self-signed=true,ssl-cert-common-name=quest.com \
Specify the FMS URL that FoglightAgentManager will connect to. Here is using the HTTPS conncention. 

* installer.noservice \
On Windows, do not install FoglightAgentManager as a service. On UNIX, do not install an init.d script to automatically start FoglightAgentManager. 

* installer.silent \
Install FoglightAgentManager without prompting for configuration options. Default values will be used unless they are overridden on the command line. 

* installer.host-display-name=${HOST_DISPLAY_NAME} \
Manually set the display name used to identify this FglAM instance. 

* installer.auth-token=${AUTH_TOKEN} \
Register auth-token during installation. This token is generated from the FMS Server and provides authorization for this client to connect. You can generate the token from MBean console: ${FMS_URL}:8080/jmx-console/ -> FglAM -> name=TokenManager -> generateAuthToken() by invoking it with no parameter. 


## FglAM-{version}-linux-x86_64.bin
This file must be downloaded from the FMS server which have installed the FglAM-linux-x86_64-{version}.car or FglAM-all-{version}.car. You can download it from 'Dashboards' -> 'Administration' -> 'Cartridges' -> 'Compoents for Download' page.
