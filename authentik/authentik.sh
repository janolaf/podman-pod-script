#!/bin/bash

# create pod and open http port 9000 and https port 9443
# create network
podman pod create --replace --name authentik -p 9000:9000 -p 9443:9443
podman network create authentik

mkdir -p /opt/authentik/db
mkdir -p /opt/authentik/custom-templates
mkdir -p /opt/authentik/media
mkdir -p /opt/authentik/backups

# create Authentik Redis container
podman container create --name authentik-redis \
    --pod authentik \
    --replace \
	--label 'io.containers.autoupdate=registry' \
    docker.io/redis:alpine

# create Authentik database container (Postgresql)
podman container create --name authentik-db \
    --pod authentik \
    --replace \
	--label 'io.containers.autoupdate=registry' \
	-e POSTGRES_USER="authentik" \
	-e POSTGRES_PASSWORD="IrXI1iozo72RBjEPNqTKMmeIa0E97nomX2agQSH0" \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
	-v /opt/authentik/db:/var/lib/postgresql/data/pgdata:z \
    docker.io/postgres:14-alpine

# create Authentik-Server container
podman container create --pod authentik \
    --name authentik-server \
    --replace \
	--label 'io.containers.autoupdate=registry' \
	-e AUTHENTIK_REDIS__HOST=127.0.0.1 \
    -e AUTHENTIK_POSTGRESQL__HOST=127.0.0.1 \
    -e AUTHENTIK_POSTGRESQL__USER=authentik \
    -e AUTHENTIK_POSTGRESQL__NAME=authentik \
    -e AUTHENTIK_POSTGRESQL__PASSWORD="IrXI1iozo72RBjEPNqTKMmeIa0E97nomX2agQSH0" \
    -e AUTHENTIK_SECRET_KEY="SDCdtYtaHnlAzSr63fTIASYqqOfDQlNtECPIzFx1969JqdhO6A" \
    -v /opt/authentik/media:/media:z \
    -v /opt/authentik/custom-templates:/templates:z \
    ghcr.io/goauthentik/server \
    server

# create Authentik-work container
podman container create --pod authentik \
    --name authentik-worker \
    --replace \
    --label 'io.containers.autoupdate=registry' \
    -e AUTHENTIK_REDIS__HOST=127.0.0.1 \
    -e AUTHENTIK_POSTGRESQL__HOST=127.0.0.1 \
    -e AUTHENTIK_POSTGRESQL__USER=authentik \
    -e AUTHENTIK_POSTGRESQL__NAME=authentik \
    -e AUTHENTIK_POSTGRESQL__PASSWORD="IrXI1iozo72RBjEPNqTKMmeIa0E97nomX2agQSH0" \
    -e AUTHENTIK_SECRET_KEY="SDCdtYtaHnlAzSr63fTIASYqqOfDQlNtECPIzFx1969JqdhO6A" \
    -v /opt/authentik/media:/media:z \
    -v /opt/authentik/custom-templates:/templates:z \
    -v /opt/authentik/backups:/backups:z \
    ghcr.io/goauthentik/server \
    worker

# create Authentik LDAP container
podman container create --pod authentik \
   	--name authentik-ldap \
    --replace \
   	--label 'io.containers.autoupdate=registry' \
   	-e AUTHENTIK_HOST=https://sso.home.janolaf.ca \
   	-e AUTHENTIK_INSECURE=false \
   	-e AUTHENTIK_TOKEN=TOKEN \
   	ghcr.io/goauthentik/ldap
