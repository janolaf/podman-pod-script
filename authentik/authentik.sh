#!/bin/bash

# create pod and open http port 9000 and https port 9443
# create network
podman pod create --replace --name authentik -p 9000:9000 -p 9443:9443
podman network create authentik

mkdir -p /opt/authentik/db
mkdir -p /opt/authentik/custom-templates
mkdir -p /opt/authentik/media
mkdir -p /opt/authentik/certs
mkdir -p /opt/authentik/backups

# generate random strings and store them as podman secrets
openssl rand -base64 36 | podman secret create authentik-postgres-secret -
openssl rand -base64 36 | podman secret create authentik-key -

# create Authentik Redis container
podman container create --name authentik-redis \
    --pod authentik \
    --replace \
	--label 'io.containers.autoupdate=registry' \
	-v authentik-radis:/data:z \
    docker.io/redis:alpine

# create Authentik database container (Postgresql)
podman container create --name authentik-db \
    --pod authentik \
    --replace \
	--label 'io.containers.autoupdate=registry' \
	-e POSTGRES_USER="authentik" \
	-e POSTGRES_DB="authentik" \
	--secret authentik-postgres-secret,type=env,target=POSTGRES_PASSWORD \
	-v /opt/authentik/db:/var/lib/postgresql/data:z \
    docker.io/postgres:12-alpine

# create Authentik-Server container
podman container create --pod authentik \
    --name authentik-server \
    --replace \
	--label 'io.containers.autoupdate=registry' \
	-e AUTHENTIK_REDIS__HOST=authentik-redis \
    -e AUTHENTIK_POSTGRESQL__HOST=authentik-db \
    -e AUTHENTIK_POSTGRESQL__USER="authentik" \
    -e AUTHENTIK_POSTGRESQL__NAME="authentik" \
    --secret authentik-postgres-secret,type=env,target=AUTHENTIK_POSTGRESQL__PASSWORD \
	--secret authentik-key,type=env,target=AUTHENTIK_SECRET_KEY \
    -v /opt/authentik/media:/media:z \
    -v /opt/authentik/certs:/certs:z \
    -v /opt/authentik/custom-templates:/templates:z \
    ghcr.io/goauthentik/server \
    server

# create Authentik-work container
podman container create --pod authentik \
    --name authentik-worker \
    --replace \
    --label 'io.containers.autoupdate=registry' \
    -e AUTHENTIK_REDIS__HOST=authentik-redis \
    -e AUTHENTIK_POSTGRESQL__HOST=authentik-db \
    -e AUTHENTIK_POSTGRESQL__USER="authentik" \
    -e AUTHENTIK_POSTGRESQL__NAME="authentik" \
    --secret authentik-postgres-secret,type=env,target=AUTHENTIK_POSTGRESQL__PASSWORD \
	--secret authentik-key,type=env,target=AUTHENTIK_SECRET_KEY \
    -v /opt/authentik/media:/media:z \
    -v /opt/authentik/custom-templates:/templates:z \
    -v /opt/authentik/certs:/certs:z \
    ghcr.io/goauthentik/server \
    worker

# create Authentik LDAP container
#podman container create --pod authentik \
#   	--name authentik-ldap \
#    --replace \
#   	--label 'io.containers.autoupdate=registry' \
#   	-e AUTHENTIK_HOST=https://sso.domain.ltd \
#   	-e AUTHENTIK_INSECURE=false \
#   	--secret authentik-token,type=env,AUTHENTIK_TOKEN=TOKEN \
#   	ghcr.io/goauthentik/ldap
