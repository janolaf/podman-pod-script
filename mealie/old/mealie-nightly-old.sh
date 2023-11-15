podman pod create --replace \
	--name mealie -p 10006:9000

podman container create --name mealie-app --pod mealie \
	--replace \
	--volume /opt/mealie/data:/app/data:z \
	--tz=America/Winnipeg \
	-e ALLOW_SIGNUP=true \
	-e BASE_URL='http://food.yourdomain.local' \
    -e MAX_WORKERS=1 \
    -e WEB_CONCURRENCY=1 \
	--label io.containers.autoupdate=registry ghcr.io/mealie-recipes/mealie:nightly \
    ghcr.io/mealie-recipes/mealie:nightly
