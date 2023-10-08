# This file is provided for testing
# Recommend using Quadlet to manage containers

podman container create --name mealie \
    -p 10006:9000 \
    -e ALLOW_SIGNUP=true \
    --tz America/Winnipeg \
    --replace \
    -e MAX_WORKERS=1 \
    -e WEB_CONCURRENCY=1 \
    -e BASE_URL=https://food.domain.local \
    -v /opt/mealie/data:/app/data:z\
    ghcr.io/mealie-recipes/mealie:nightly
