#!/bin/bash

# create pod and open http port 9000 and https port 9443
# create network
podman pod create --name authentik -p 9000:9000 -p 9443:9443
podman network create authentik
podman unshare chown -R authentik: /opt/authentik

# create Authentik Redis container
podman container create --name authentik-redis --pod authentik \
	--label io.containers.autoupdate=registry \
	redis:alpine

# create Authentik database container (Postgresql)
podman container create --name authentik-db --pod authentik \
	--label io.containers.autoupdate=registry \
	-e POSTGRES_USER="authentik" \
	-e POSTGRES_PASSWORD="IrXI1iozo72RBjEPNqTKMmeIa0E97nomX2agQSH0" \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
	-v /opt/authentik/db:/var/lib/postgresql/data/pgdata:z \
	postgres:14-alpine

# create Authentik-Server container
podman container create --pod authentik \
    --name authentik-server \ 
	--label io.containers.autoupdate=registry \
	-e AUTHENTIK_REDIS__HOST=127.0.0.1 \
    -e AUTHENTIK_POSTGRESQL__HOST=127.0.0.1 \
    -e AUTHENTIK_POSTGRESQL__USER=authentik \
    -e AUTHENTIK_POSTGRESQL__NAME=authentik \
    -e AUTHENTIK_POSTGRESQL__PASSWORD="IrXI1iozo72RBjEPNqTKMmeIa0E97nomX2agQSH0" \
    -e AUTHENTIK_SECRET_KEY=SDCdtYtaHnlAzSr63fTIASYqqOfDQlNtECPIzFx1969JqdhO6A \
    -v /opt/authentik/media:/media:z \
    -v /opt/authentik/custom-templates:/templates:z \
    ghcr.io/goauthentik/server \
    server

# create Authentik-work container
podman container create --pod authentik \
    --name authentik-worker \
    --label 'io.containers.autoupdate=registry' \
    -e AUTHENTIK_REDIS__HOST=127.0.0.1 \
    -e AUTHENTIK_POSTGRESQL__HOST=127.0.0.1 \
    -e AUTHENTIK_POSTGRESQL__USER=authentik \
    -e AUTHENTIK_POSTGRESQL__NAME=authentik \
    -e AUTHENTIK_POSTGRESQL__PASSWORD=IrXI1iozo72RBjEPNqTKMmeIa0E97nomX2agQSH0 \
    -e AUTHENTIK_SECRET_KEY=SDCdtYtaHnlAzSr63fTIASYqqOfDQlNtECPIzFx1969JqdhO6A \
    -v /opt/authentik/media:/media:z \
    -v /opt/authentik/custom-templates:/templates:z \
    -v /opt/authentik/backups:/backups:z \
    ghcr.io/goauthentik/server \
    worker

# create Authentik LDAP container
podman container create --pod authentik \
   	--name authentik-ldap \
   	--label 'io.containers.autoupdate=registry' \
   	-e AUTHENTIK_HOST=https://sso.home.janolaf.ca \
   	-e AUTHENTIK_INSECURE=false \
   	-e AUTHENTIK_TOKEN=TOKEN \
   	ghcr.io/goauthentik/ldap
