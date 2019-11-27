FROM ubuntu
MAINTAINER fglam@quest.com
RUN apt-get update \
&& apt-get -y install \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
WORKDIR /FglAM
COPY FglAM-{version}-linux-x86_64.bin /FglAM
COPY installer.properties /FglAM
RUN chmod +x FglAM-{version}-linux-x86_64.bin
COPY docker-entrypoint.sh /FglAM
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT /FglAM/docker-entrypoint.sh
