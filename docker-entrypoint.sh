#!/bin/sh

cp /home/node/peertube/support/docker/production/config/* /config

exec "$@"
