FROM node:10-alpine

ARG TAG=v1.0.0-beta.10

RUN apk update && \
    apk add --no-cache bash curl glib-dev expat-dev tiff-dev libjpeg-turbo-dev libgsf-dev ffmpeg openssl gnupg gcc git python make g++ && \
    apk add imagemagick-libs imagemagick imagemagick-dev && \
    mkdir /home/node/.npm-global && \
    mkdir /home/node/app && \
    mkdir /data && \ 
    mkdir /config && \
    git clone https://github.com/Chocobozzz/PeerTube /home/node/peertube && \
    cd /home/node/peertube && \
    git checkout tags/$TAG

# Make libvips
RUN cd /tmp && \
    wget https://github.com/jcupitt/libvips/releases/download/v8.7.0-rc1/vips-8.7.0.tar.gz && \
    tar -xvf vips-8.7.0.tar.gz && \
    cd vips-8.7.0 && \
    ./configure && \
    make && make install 
    

# Building peertube
RUN chown -R node:node /home/node/app && \
    chown -R node:node /home/node/.npm-global && \
    chown -R node:node /home/node/peertube && \
    chown -R node:node /config && \
    chown -R node:node /data

USER node

ENV PATH=/home/node/.npm-global/bin:/home/node/node_modules/.bin/:$PATH
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

RUN cd /home/node/peertube && \
    npm install -Dg angular @angular/cli typescript vips sharp libxmljs . && \
    npm run build && \
    rm -rf /home/node/peertube/node_modules && \
    rm -rf /home/node/peertube/.git && \
    rm -rf /home/node/peertube/client; exit 0 

# Cleanup a little
USER root

RUN apk del gcc git make g++ imagemagick-dev

USER node

ENV NODE_CONFIG_DIR=/config
ENV NODE_ENV=production 

VOLUME ["/data", "/config"]
EXPOSE 9000

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
#CMD ["/bin/bash"]
