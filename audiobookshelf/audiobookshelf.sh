#/bin/bash
podman pod create --name audiobookshelf -p 10003:80 --replace

# Must install udici to create SELinux policy. 

podman container create --pod audiobookshelf --name abs-app \
	--replace \
	--label io.containers.autoupdate=local \
	--security-opt "label=type:audiobookshelf.process" \
	-v /opt/audiobookshelf/config:/config:Z \
	-v /opt/audiobookshelf/metadata:/metadata:Z \
	-v /path/to/audiobooks:/audiobooks:ro \
	ghcr.io/advplyr/audiobookshelf:latest

# TODO -- Addd Udici instructions 
