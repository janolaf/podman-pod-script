podman pod create --name keycloak -p 10000:8080 --replace 

podman container create --name keycloak-db \
    --replace \
    --pod keycloak \
    --name myPostgresDB \
    -v keycloak-pgdata:/var/lib/postresql/data \
    -e POSTGRES_USER=keycloak_user \
    -e POSTGRES_PASSWORD=empireatwar \
    -e POSTGRES_DB=keycloakDB \
    docker.io/postgres:16

podman container create --name keycloak-app \
    --replace \
    --pod keycloak \
    -e KEYCLOAK_ADMIN=admin \
    -e KEYCLOAK_ADMIN_PASSWORD=admin \
    -e KC_DB=postgres \
    -e KC_DB_URL_DATABASE=keycloakDB \
    -e KC_DB_URL_HOST=localhost \
    -e KC_DB_URL_PORT=5432 \
    -e KC_DB_USERNAME=keycloak_user \
    -e KC_DB_PASSWORD=empireatwar \
    quay.io/keycloak/keycloak:latest start-dev
