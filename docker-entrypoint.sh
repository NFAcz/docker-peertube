#!/bin/sh

#cp /home/node/peertube/support/docker/production/config/* /config

cd /home/node/peertube

exec node dist/server
