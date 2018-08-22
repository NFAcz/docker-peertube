#!/bin/bash

PEERTUBE_CONFIG="/config/production.yaml"

if [ -f "$PEERTUBE_CONFIG" ]; then
	cd /home/node/peertube/
	NODE_ENV=production node dist/server
else
	cp /home/node/peertube/support/docker/production/config/* /config
	echo "A default config file has been placed in the /config/ volume please review and make any required changes and start the container again"
fi
