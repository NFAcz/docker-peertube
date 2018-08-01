# Docker image to host a peertube instance

This docker image include a single process peertube instance. Compared to the original one, it has no systemd, no webserver, no database inside and it's not based on debian, it's based on alpine.

## How u have to start it! 

1. First you need a volume with a working production configuration of peertube. This file have to called ```production.yaml```
2. You need a working external postgresql database
3. You need a working external redis caching database
4. You need a working smtp account

If you have everything, then just start the container like this:

```bash

docker volume create peertubeconfig
docker volume create peertubedata

docker run -v peertubeconfig:/config:rw -v peertubedata:/data:rw -p 80:9000 avhost/docker-peertube:master
```

Now you can access your peertube instance via port 80. If you configure peertube with ssl, you will change the port from 80 to 443.

## Tagged Version

If you want to use this image in production, please conside to use the version tagged dockerimages. https://hub.docker.com/r/avhost/docker-peertube/tags/

