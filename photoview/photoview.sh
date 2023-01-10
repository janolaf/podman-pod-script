podman pod create --replace --name photoview -p 8000:80

podman container create --pod photoview --name photoview-db \
	--replace \
	-e MYSQL_DATABASE=photoview \
	-e MYSQL_USER=photoview \
	-e MYSQL_PASSWORD=changeMe \
	-e MYSQL_RANDOM_ROOT_PASSWORD=1 \
	-v /opt/photoview/data:/var/lib/mysql:z \
	mariadb:10.5

podman container create --pod photoview --name photoview-app \
	--replace \
	-e PHOTOVIEW_DATABASE_DRIVER=mysql \
    -e "PHOTOVIEW_MYSQL_URL=photoview:changeMe@tcp(localhost)/photoview" \
    -e PHOTOVIEW_LISTEN_IP=photoview \
    -e PHOTOVIEW_LISTEN_PORT=80 \
    -e PHOTOVIEW_MEDIA_CACHE=/app/cache \
	-v /opt/photoview/cache:/app/cache:z \
	-v /path/to/photos:/photos:ro \
	viktorstrate/photoview:2
