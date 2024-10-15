#!/bin/bash

set -e

if [[ ! -f /opt/nginx-proxy-redirect/data/config.yml ]]; then
	cp /opt/nginx-proxy-redirect/config.yml.example /opt/nginx-proxy-redirect/data/config.yml
fi

export CONFIG="$(yq -oj . /opt/nginx-proxy-redirect/data/config.yml)"
dockerize -template /opt/nginx-proxy-redirect/etc/nginx.tmpl.conf:/opt/nginx-proxy-redirect/data/nginx.conf
exec nginx -c /opt/nginx-proxy-redirect/data/nginx.conf "$@"
