#!/bin/bash

podman run -d \
    --name typemill \
    -p 10010:80 \
    --userns=keep-id \
    -v /opt/typemill/settings:/var/www/html/settings/ \
    -v /opt/typemill/cache:/var/www/html/cache/ \
    -v /opt/typemill/content:/var/www/html/content/ \
    -v /opt/typemill/media:/var/www/html/media/ \
    -v /opt/typemill/themes:/var/www/html/themes/ \
    aberty/typemill-docker
