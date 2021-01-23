#!/bin/sh
podman pod create photoview-pod -p 8000:80

podman create --name photoview --pod photoview-pod
    -e PHOTOVIEW_DATABASE_DRIVER=mysql
    -e PHOTOVIEW_MYSQL_URL=photoview:photosecret@tcp(db)/photoview
    -e PHOTOVIEW_LISTEN_IP=photoview
    -e PHOTOVIEW_LISTEN_PORT=80
    -e PHOTOVIEW_MEDIA_CACHE=/app/cache
    -e PHOTOVIEW_PUBLIC_ENDPOINT=http://localhost:8000/
    -e MAPBOX_TOKEN=<YOUR TOKEN HERE>
    -v /var/lib/photoview/cache:/app/cache
    -v ./photo_path:/photos:ro
    viktorstrate/photoview:2

podman create --name photoview-db --pod photoview-pod
    -e MYSQL_DATABASE=photoview
    -e MYSQL_USER=photoview
    -e MYSQL_PASSWORD=photosecret
    -e MYSQL_RANDOM_ROOT_PASSWORD=1
    -v db_data:/var/lib/mysql
