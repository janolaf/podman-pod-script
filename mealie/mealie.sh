podman pod create --name mealie -p 10006:3000

podman container create --name mealie-api --pod mealie \
<<<<<<< HEAD
	-v /opt/mealie/data:/app/data:z \
	-e ALLOW_SIGNUP=true \
	-e MAX_WORKERS=1 \
	-e WEB_CONCURRENCY=1 \
       	-e BASE_URL=http://food.home.janolaf.ca \
	hkotel/mealie:api-v1.0.0beta-5

podman container create --name mealie-frontend --pod mealie \
	-v /opt/mealie/data:/app/data:z \
	-e API_URL=http://mealie-api:9000 \
	hkotel/mealie:frontend-v1.0.0beta-5
=======
        -v /opt/mealie/data:/app/data:z \
        -e ALLOW_SIGNUP=true \
        -e MAX_WORKERS=1 \
        -e WEB_CONCURRENCY=1 \
        -e TZ=UTC \
        -e BASE_URL=http://food.home.janolaf.ca \
        hkotel/mealie:api-v1.0.0beta-4

podman container create --name mealie-frontend --pod mealie \
        -v /opt/mealie/data:/app/data:z \
        -e API_URL=http://mealie-api:9000 \
        hkotel/mealie:frontend-v1.0.0beta-4
>>>>>>> 87c5c6ab1a31c10cb08001edf2f070aa50d0b801
