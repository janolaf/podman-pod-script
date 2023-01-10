#/bin/bash
podman pod create --name audiobookshelf-pod -p 10003:80 --replace

# Must install udici to create SELinux policy. 

podman container create --pod audiobookshelf-pod --name audiobookshelf-app \
	--label io.containers.autoupdate=local \
	--security-opt "label=type:audiobookshelf-app.process" \
	-v /opt/audiobookshelf/config:/config:Z \
	-v /opt/audiobookshelf/metadata:/metadata:Z \
	-v /audiobooks:/audiobooks:ro \
	--replace \
	ghcr.io/advplyr/audiobookshelf:latest

# TODO -- Addd Udici instructions 
