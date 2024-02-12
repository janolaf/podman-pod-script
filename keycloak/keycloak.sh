podman pod --replace --name keycloak -p 10000:8080 --network keycloak-network

podman network create keycloak-network

openssl rand -base64 36 | podman secret create keycloak-postgres-secret -
openssl rand -base64 36 | podman secret create keycloak-admin-secret -

podman container create --pod keycloak --name keycloak-db \
	-v pgdata:/var/lib/postgresql/data:z \
	-e POSTGRES_DB="keycloak_db" \
	-e POSTGRES_USER="keycloak_user" \
	-secret keycloak-postgres-secret,type=env,target=POSTGRES_PASSWORD \
	docker.io/postgres:16


podman container create --pod keycloak --name keycloak-app \
	-e KC_LOG_LEVEL="debug" \
	-e KC_DB="postgres" \
	-e KC_DB_URL="jdbc:postgresql://postgres_db/keycloak" \
	-e KC_DB_USERNAME="keycloak_user" \
	--secret keycloak-postgres-secret,type=env,target=KC_DB_PASSWORD \
	-e KC_DB_SCHEMA="public" \
	--secret keycloak-hostname,type=env,target=KC_HOSTNAME \
	-e KC_HOSTNAME_STRICT_HTTPS=true \
	-e KC_HOSTNAME_STRICT=true \
	-e KC_PROXY=edge \
	-e HTTP_ADDRESS_FORWARDING=true \
	-e KEYCLOAK_ADMIN=admin \
	--secret keycloak-admin-secret,type=env,target=KEYCLOAK_ADMIN_PASSWORD \
	# start --optimized
	quay.io/keycloak/keycloak:23.0
