# VERSION CONTROL
FROM python:3.7.7-slim-stretch
ENV NODE_VERSION=14
ENV ANGULAR_VERSION=11
# TODO: Figure out how to pass in versions through the ARG command and docker-compose.yml 
#       used in conjunction.

# MAKE APPLICATION
WORKDIR /home/
RUN mkdir /app && mkdir /frontend && mkdir /scripts
COPY /app/requirements.txt /home/app/requirements.txt

# INSTALL DEPENDENCIES
RUN apt-get update -y && apt-get install -y curl wait-for-it
WORKDIR /home/app/
RUN pip install -r requirements.txt
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs
COPY /frontend/package.json /home/frontend/
WORKDIR /home/frontend/
RUN npm install -g @angular/cli@${ANGULAR_VERSION}
RUN npm install

# MOUNT VOLUMES
VOLUME /home/app /home/frontend /home/scripts

# BOOTSTRAP
WORKDIR /home/scripts/
CMD ["bash", "./bootstrap.sh", "container"]