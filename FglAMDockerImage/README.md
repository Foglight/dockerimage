# FglAMDockerImage
If you want to pick up the Docker file and build the image by yourself, you need to prepare the following files before the building: \
Need to pull the ubuntu image. \
Need a FglAM installer file(FglAM-{version}-linux-x86_64.bin). \
Need to put the Dockerfile, FglAM_installer file, docker-entrypoint.sh and installer.properties to the same folder and build it.

Image building: \
docker build -t $IMAGE_NAME:tag .

For example: \
docker build -t fglamimg:latest .

How to run the FglAMDockerImage: \
You can pull the image on docker hub(name: zakeguo/fglam_docker_image), or you can build it by yourself as the above steps.

Image running: \
docker run -dit \
--name $CONTAINER_NAME \
-e FMS_URL=$FMS_URL \
-e HOST_DISPLAY_NAME=$HOST_DISPLAY_NAME \
-e AUTH_TOKEN=$AUTH_TOKEN \
$IMAGE_NAME:latest

For example: \
docker run -dit \
--name dockerfglam \
-e FMS_URL=10.154.14.14 \
-e HOST_DISPLAY_NAME=DockerFglAMTest \
-e AUTH_TOKEN= encrypted:be054a065b65b7947054a21453fa64d570df441e46c49ab073039a48c893a392da5b289af8925d864d4e9831ba21fc3ad0383cae86be2b5fc3783a329bfdd1dc1a04c86c557b21596def6ceeffd97bfdb58afbed5dbf31bba6c3d62c31758ebcf0d8941b6a317b41b93f72c4d18c2919 \
fglamimg:latest


# Instructions
Dockerfile: \
-update the apt lib. \
-define the WORKDIR. \
-copy the FglAM installer to the WORKDIR and install it using HTTPS connection to FMS_URL. \
-execute the docker-entrypoint scrip to install FglAM and start it up, then print the latest log. 

docker-entrypoint.sh: \
This script will execute when running the fglamimg to the container, when setting the -e FMS_URL, HOST_DISPLAY_NAME, AUTH_TOKEN parameters to the installer.properties file, it will start to install the FglAM instance and start it up automatically. Then print the latest log on the container console. 

installer.properties: \
- installer.installdir=/opt/fglam  #Set the directory that FoglightAgentManager will be installed to. \
- installer.fms=url=https://${FMS_URL}:8443,ssl-allow-self-signed=true,ssl-cert-common-name=quest.com #Specify a URL that FoglightAgentManager will connect to. Here is using the HTTPS conncention. \
- installer.noservice  #On Windows, do not install FoglightAgentManager as a service. On UNIX, do not install an init.d script to automatically start FoglightAgentManager. \
- installer.silent  #Install FoglightAgentManager without prompting for configuration options. Default values will be used unless they are
overridden on the command line. \
- installer.host-display-name=${HOST_DISPLAY_NAME}  #Manually set the display name used to identify this FglAM instance. \
- installer.auth-token=${AUTH_TOKEN}  #Register auth-token during install. This token is generated from the FMS Server and provides authorization for this client to connect. You can generate the token from MBean console: ${FMS_URL}:8080/jmx-console/ -> FglAM -> name=TokenManager -> generateAuthToken(), Invoke it with no parameter setting. 

FglAM-{version}-linux-x86_64.bin \
This file must download from the FMS server which have installed the FglAM-linux-x86_64-{version}.car or FglAM-all-{version}.car. You can download it from 'Dashboards' -> 'Administration' -> 'Cartridges' -> 'Compoents for Download' page.
