podman pod create --name photoprism -p 10009:2342

podman container create --name photoprism-db --pod photoprism \
	--restart unless-stopped \
	--label io.containers.autoupdate=registry \
	-v /opt/photoprism/db:/var/lib/mysql:Z \
	-e MYSQL_ROOT_PASSWORD=insecure \
	-e MYSQL_DATABASE=photoprism \
	-e MYSQL_USER=photoprism \
	-e MYSQL_PASSWORD=insecure \
	docker.io/library/mariadb:10.6 mysqld --innodb-buffer-pool-size=128M --transaction-isolation=READ-COMMITTED --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --max-connections=512 --innodb-rollback-on-timeout=OFF --innodb-lock-wait-timeout=120

podman container create --name photoprism-app --pod photoprism \
	--label io.containers.autoupdate=registry \
	--userns=keep-id \
	-v /opt/photoprism/original:/photoprism/originals:z \
	-v /opt/photoprism/storage:/photoprism/storage:Z \
	-v /opt/photoprism/imports:/photoprism/imports:z \
	-e PHOTOPRISM_ADMIN_PASSWORDi="insecure"          
      	-e PHOTOPRISM_SITE_URL="http=//localhost:2342/" \
      	-e PHOTOPRISM_ORIGINALS_LIMIT=5000 \
      	-e PHOTOPRISM_HTTP_COMPRESSION="gzip" \
      	-e PHOTOPRISM_DEBUG="false" \
      	-e PHOTOPRISM_PUBLIC="false" \
      	-e PHOTOPRISM_READONLY="false" \
      	-e PHOTOPRISM_EXPERIMENTAL="false" \
      	-e PHOTOPRISM_DISABLE_CHOWN="false" \
      	-e PHOTOPRISM_DISABLE_WEBDAV="false" \
      	-e PHOTOPRISM_DISABLE_SETTINGS="false" \
      	-e PHOTOPRISM_DISABLE_TENSORFLOW="false" \
      	-e PHOTOPRISM_DISABLE_FACES="false" \
      	-e PHOTOPRISM_DISABLE_CLASSIFICATION="false" \
      	-e PHOTOPRISM_DARKTABLE_PRESETS="false" \
      	-e PHOTOPRISM_DETECT_NSFW="false" \
      	-e PHOTOPRISM_UPLOAD_NSFW="true" \
      	-e PHOTOPRISM_DATABASE_DRIVER="mysql" \
      	-e PHOTOPRISM_DATABASE_SERVER="mariadb:3306" \
      	-e PHOTOPRISM_DATABASE_NAME="photoprism" \
      	-e PHOTOPRISM_DATABASE_USER="photoprism" \
      	-e PHOTOPRISM_DATABASE_PASSWORD="insecure" \
      	-e PHOTOPRISM_SITE_TITLE="PhotoPrism" \
      	-e PHOTOPRISM_SITE_CAPTION="AI-Powered Photos App" \
      	-e PHOTOPRISM_SITE_DESCRIPTION="" \
      	-e PHOTOPRISM_SITE_AUTHOR="" \
      	-e PHOTOPRISM_INIT="gpu tensorflow" \
      	-e PHOTOPRISM_UID=1000 \
      	-e PHOTOPRISM_GID=1000 \
    	--device="/dev/dri:/dev/dri" \
	photoprism/photoprism:latest
