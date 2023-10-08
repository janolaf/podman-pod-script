# Mealie

Mealie Recipes has moved back to a single container, and moved development to Github. 

`mealie-api` and `mealie-frontend` is no longer maintained.

`mealie-nightly.sh` is provided for those using podman 4.3 or earlier. It is not a pod. If you are using podman 4.4 or later, I recommend that you use `mealie.container` in the quadlet directory to manage containers.

Both the shell script and the quadlet container are drop in replacements for the yaml or pod shell script. Both the shell script and the quadlet store data in `/opt/mealie/data`. you will need to create the directory and change ownership

### Make directories

`mkdir -p /opt/mealie/data`

`chown $USER: -R /opt/mealie/`

## Quadlets

Quadlets are `.container`, `.volume`, `.network`, `.kube`, `image` files which generate a service file.

If you are using `mealie.container`, make sure that `~/.config/container/systemd` is created and copy `mealie.container` into the directory.

Run:

`systemctl --user daemon-reload`

Then Run:

`systemctl --user start mealie.service`

Quadlet and systemctl will manage it on boot.
