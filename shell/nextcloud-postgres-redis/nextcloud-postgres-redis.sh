#!/bin/sh
# Must thank Bilal Kalem for helping me to understand podman pods.
# This script borrowed from https://ios.dz/deployer-un-pod-sur-podman/
# CC BY-NC 4.0
# change port to {computer port}:80 (container port}
# make usre you open ports
# Centos Streams/RHEL 8/Fedora 33+ firewall-cmd --add-port-8050/tcp --permanent
# firewall-cmd --reload


podman pod create --name nextcloud-pod -p 8050:80

podman container create  --name nextcloud-db --pod nextcloud-pod \
	-e POSTGRES_USER="nextcloud" \
	-e POSTGRES_PASSWORD="topsecret" \
	postgres:13

podman container create --name nextcloud-redis --pod nextcloud-pod \
	redis

podman container create --name nextcloud --pod nextcloud-pod
	-e POSTGRES_HOST="127.0.0.1" \
	-e POSTGRES_DB="nextcloud" \
	-e POSTGRES_USER="nextcloud" \
	-e POSTGRES_PASSWORD="topsecret" \
	-e NEXTCLOUD_ADMIN_USER="nextcloud" \
	-e NEXTCLOUD_ADMIN_PASSWORD="secret" \
	-e NEXTCLOUD_TRUSTED_DOMAINS="192.168.0.3" \
	-e REDIS_HOST="127.0.0.1" \
	nextcloud



