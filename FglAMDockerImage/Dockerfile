FROM ubuntu
MAINTAINER fglam@quest.com
RUN apt-get update \
&& apt-get -y install \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
WORKDIR /FglAM592
COPY FglAM-5_9_2-linux-x86_64.bin /FglAM592
COPY installer.properties /FglAM592
RUN chmod +x FglAM-5_9_2-linux-x86_64.bin
COPY docker-entrypoint.sh /FglAM592
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT /FglAM592/docker-entrypoint.sh
