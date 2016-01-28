# ----------------------------------------------------------------------------------------------
# General NodeJS Development Container
# Build command
# docker build -t nixhatter/nodedev .
# Running the container
# Make sure to set the port to your specific web app
# docker run --name NodeDev -d -p 4000:4000 -v /host/volume:/var/www nixhatter/nodedev
# ----------------------------------------------------------------------------------------------

FROM centos:latest
MAINTAINER Dillon Aykac <dillon@nixx.co>
LABEL Description="Node, Express and some other stuff" Vendor="NiXX" Version="1.0"

# Let's install all the dependencies
RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install git which inotify-tools

RUN yum install -y nodejs npm && npm config set loglevel warn

# Install Grunt
RUN npm install -g grunt-cli

RUN mkdir /var/internal

RUN echo "inotifywait -r -m /var/www | while read" >> inotify.sh
RUN echo "do" >> inotify.sh
RUN echo "rsync -a --exclude=node_modules --delete /var/www/ /var/internal/" >> inotify.sh
RUN echo "done" >> inotify.sh

# Setup the Volume
VOLUME ["/var/www"]

# Expose Ports
EXPOSE 4000

# Let's go go go
CMD sh inotify.sh & \
sleep 3 && \
rsync -a /var/www/ /var/internal/ && \
cd /var/internal && \
npm install && \
grunt
