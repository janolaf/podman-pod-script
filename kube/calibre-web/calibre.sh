podman run -d --name=calibre-web \
	-e PUID=1000 \
	-e PGID=1000 \
	-e TZ=America/Winnipeg \
	-e DOCKER_MODS=linuxserver/calibre-web:calibre \
	-e OAUTHLIB_RELAX_TOKEN_SCOPE=1 \
	-p 10008:8083 \
	-v /opt/calibre/data:/config:Z \
	-v '/srv/share/books/Calibre Library':/books \
	--restart unless-stopped \
	lscr.io/linuxserver/calibre-web:latest
