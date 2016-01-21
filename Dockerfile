# ----------------------------------------------------------------------------------------------
# General NodeJS Development Container
# Build command
# docker build -t nixhatter/nodedev .
# Running the container
# Make sure to set the port to your specific web app
# docker run --name NodeDev -d -p 4000:4000 -v /C/Programming/nodedev:/var/www nixhatter/nodedev
# ----------------------------------------------------------------------------------------------

FROM centos:latest
MAINTAINER Dillon Aykac <dillon@nixx.co>
LABEL Description="Node, Express and some other stuff" Vendor="NiXX" Version="1.0"

WORKDIR "/var/www"

# Let's install all the dependencies
RUN yum -y update; yum clean all
RUN yum -y group install "Development Tools"        # Dev tools are optional
RUN yum -y install epel-release; yum clean all
RUN yum -y install nginx git which

# Having some problems using NVM, so we'll use the repo version of node for now
#RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
#RUN . ~/.nvm/nvm.sh && nvm install 0.12
RUN yum install -y nodejs npm

# OPTIONAL :: Install Grunt
RUN npm install -g grunt-cli

# Setup the Volume
VOLUME ["/var/www"]

# Expose Ports
EXPOSE 4000

# Let's go go go
CMD cd /var/www && npm install --no-bin-links && ls && grunt --gruntfile /var/www/GruntFile.js
