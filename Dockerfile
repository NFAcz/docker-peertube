FROM node:10-alpine

ARG TAG=v1.0.0-beta.9

RUN apk update && \
    apk add --no-cache bash curl glib-dev expat-dev tiff-dev libjpeg-turbo-dev libgsf-dev ffmpeg openssl gnupg gcc git python make g++ && \
    curl --compressed -o- -L https://yarnpkg.com/install.sh | bash && \
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
    

COPY ./docker-entrypoint.sh /

RUN chown -R node:node /home/node/app && \
    chown -R node:node /home/node/.npm-global && \
    chown -R node:node /home/node/peertube && \
    chown -R node:node /config && \
    chown -R node:node /data

USER node

ENV PATH=/home/node/.npm-global/bin:/home/node/node_modules/.bin/:$PATH
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV NODE_CONFIG_DIR=/config
ENV NODE_ENV=production 


RUN cd /home/node/peertube && \
    yarn install --pure-lockfile && \
    npm run build

USER root

RUN apk del gcc git make g++ imagemagick-dev

USER node

RUN cp /app/support/docker/production/config/* /config
RUN chown -R peertube:peertube /data /config

VOLUME ["/data"]
EXPOSE 9000

#ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
