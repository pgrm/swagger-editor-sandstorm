#!/bin/bash
set -euo pipefail

mkdir -p /var/lib/nginx
mkdir -p /var/log/nginx
# Wipe /var/run, since pidfiles and socket files from previous launches should go away
# TODO someday: I'd prefer a tmpfs for these.
rm -rf /var/run
mkdir -p /var/run

if [ ! -d /var/editor ]; then
    mkdir -p /var/editor
    cp /opt/app/editor/spec-files/default.yaml /var/editor/spec
fi

# Start nginx.
/usr/sbin/nginx -c /opt/app/.sandstorm/service-config/nginx.conf -g "daemon off;"
