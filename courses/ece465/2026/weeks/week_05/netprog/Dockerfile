#
# Dockerfile for my Zookeeper application
#
# docker build -t transcriptor:v1 .
ARG BASE_IMAGE=24.10
FROM ubuntu:$BASE_IMAGE
ENV APP="transcriptor"

RUN /bin/rm -rf /opt

# RUN apt-get install -y gnupg

# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys A122542AB04F24E3

RUN apt-get update && apt-get update -y

RUN apt-get install -y  openjdk-21-jdk-headless

# RUN apt-get update; apt-get install -y java-21-amazon-corretto-jdk

# TODO: remove vim, dnsutils, dos2unix for production
RUN apt-get install -y dnsutils dos2unix vim

# Copy the application into the container
RUN mkdir -p /classes
COPY ./bin/TCPServer.class /classes
COPY ./bin/TCPServer\$ClientHandler.class /classes

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN dos2unix /entrypoint.sh

# Remove unnecessary packages to increase security and reduce the size of the image
RUN apt-get remove -y --purge \
    #    gpg \
    #    wget \
    #    apt-transport-https \
    #    ca-certificates \
    #    gnupg \
    #    software-properties-common \
    dnsutils \
    dos2unix \
    && apt-get autoremove -y

EXPOSE 12345

# Set the entrypoint script to be the entrypoint for the container
#ENTRYPOINT ["/${APP}-entrypoint.sh"]

# Set the default command to be the Zookeeper application
#CMD ["java", "-jar", "/zkApp.jar"]
#CMD ["java", "-classpath /", "/TCPServer"]
#CMD ["/bin/bash"]
#CMD ["/bin/bash","-c","/transcriptor-entrypoint.sh"]
CMD ["/bin/bash","-c","/entrypoint.sh"]