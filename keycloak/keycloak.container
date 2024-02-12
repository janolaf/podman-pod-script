FROM quay.io/keycloak/keycloak:23.0.6 as builder

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# COPY --from=keycloakify_jar_builder /opt/app/build_keycloak/target/ keycloakify-starter-keycloak-theme-5.1.3.jar /opt/keycloak/providers/
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:23.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Add ENTRYPOINT
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
