#!/bin/bash

set -e

export CONFIG="$(yq . /opt/nginx-proxy-redirect/data/config.yml)"
dockerize -template /opt/nginx-proxy-redirect/etc/nginx.tmpl.conf:/opt/nginx-proxy-redirect/data/nginx.conf
exec nginx -c /opt/nginx-proxy-redirect/data/nginx.conf "$@"
