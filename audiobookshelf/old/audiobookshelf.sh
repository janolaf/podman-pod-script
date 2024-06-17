#!/bin/bash
# Must install udici to create SELinux policy.

podman container create --name audiobookshelf \
	-p 10003:80 \
	--replace \
	--label io.containers.autoupdate=registry \
	--security-opt "label=type:audiobookshelf.process" \
	-v /opt/audiobookshelf/config:/config:Z \
	-v /opt/audiobookshelf/metadata:/metadata:Z \
	-v /location/of/audiobooks:/audiobooks:ro \
	ghcr.io/advplyr/audiobookshelf:latest

# TODO -- Addd Udici instructions
