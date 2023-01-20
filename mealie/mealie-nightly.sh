podman pod create --replace --name mealie -p 10006:3000

podman container create --name mealie-api --pod mealie \
	--replace \
	--tz=America/Winnipeg \
	-v /opt/mealie/data:/app/data:z \
	-e ALLOW_SIGNUP=true \
	-e MAX_WORKERS=1 \
	-e WEB_CONCURRENCY=1 \
    -e BASE_URL=http://food.home.local \
	hkotel/mealie:api-nightly

podman container create --replace --name mealie-frontend --pod mealie \
	-v /opt/mealie/data:/app/data:z \
	-e API_URL=http://mealie-api:9000 \
	hkotel/mealie:frontend-nightly
