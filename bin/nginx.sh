#!/bin/bash

set -e

export CONFIG="$(yq . /opt/nginx-proxy-redirect/config.yml)"
dockerize -template /opt/nginx-proxy-redirect/etc/nginx.tmpl.conf:/opt/nginx-proxy-redirect/etc/nginx.conf
exec nginx -c /opt/nginx-proxy-redirect/etc/nginx.conf "$@"
