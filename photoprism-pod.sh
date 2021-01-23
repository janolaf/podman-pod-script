#!/bin/bash
# create pod for PhotoPrism
podman pod create --name photoprism-pod -p 2342:2342

# create container for PhotoPrism
podman create --name photoprism --pod photoprism-pod \
    -e PHOTOPRISM_ADMIN_PASSWORD="insecure" \
    -e PHOTOPRISM_HTTP_PORT=2342 \
    -e PHOTOPRISM_HTTP_COMPRESSION="gzip" \
    -e PHOTOPRISM_DEBUG="false" \
    -e PHOTOPRISM_PUBLIC="false" \
    -e PHOTOPRISM_READONLY="false" \
    -e PHOTOPRISM_EXPERIMENTAL="false" \
    -e PHOTOPRISM_DISABLE_WEBDAV="false" \
    -e PHOTOPRISM_DISABLE_SETTINGS="false" \
    -e PHOTOPRISM_DISABLE_TENSORFLOW="false" \
    -e PHOTOPRISM_DARKTABLE_PRESETS="false" \
    -e PHOTOPRISM_DETECT_NSFW="false" \
    -e PHOTOPRISM_UPLOAD_NSFW="true" \
    -e PHOTOPRISM_DATABASE_DRIVER="mysql" \
    -e PHOTOPRISM_DATABASE_SERVER="127.0.0.1:3306" \
    -e PHOTOPRISM_DATABASE_NAME="photoprism" \
    -e PHOTOPRISM_DATABASE_USER="photoprism" \
    -e PHOTOPRISM_DATABASE_PASSWORD="insecure" \
    -e PHOTOPRISM_SITE_URL="http://localhost:2342/" \
    -e PHOTOPRISM_SITE_TITLE="PhotoPrism"\
    -e PHOTOPRISM_SITE_CAPTION="Browse Your Life"\
    -e PHOTOPRISM_SITE_DESCRIPTION=""\
    -e PHOTOPRISM_SITE_AUTHOR=""\
    -v /srv/photos:/photoprism/originals/media \
    -v /srv/imports/photos:/photoprism/import \
    -v /var/lib/photoprism/storage:/photoprism/storage \
    docker.io/photoprism/photoprism:latest 

# create mysql database for photoprism
podman create --name photodb --pod photoprism-pod
    MYSQL_ROOT_PASSWORD=please_change \
    MYSQL_DATABASE=photoprism \
    MYSQL_USER=photoprism \
    MYSQL_PASSWORD=insecure \
    -v /var/lib/photoprism/data:/var/lib/mysql \
    docker.io/mariadb:10.5 \
    --transaction-isolation=READ-COMMITTED \
    --character-set-server=utf8mb4 \
    --collation-server=utf8mb4_unicode_ci \
    --max-connections=512 \
    --innodb-rollback-on-timeout=OFF \
    --innodb-lock-wait-timeout=50
