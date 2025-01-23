# Using Quadlet to Manage Mealie

There are two options:
    1.'mealie.container', which uses the internal SQLite database.
    2. Mealie Pod, which uses postgres 17. The Pod directory contains three files, mealie.pod, mealie-app.container and mealie-db.container.

Regardless of which you use, I store all files in /opt/melalie. If you wish to use volumes, replace /opt/mealie/data and /opt/mealie/db with appropriate volume names.

# Setup

## Create directories

`sudo mkdir -p /opt/mealie/{data,db}`

Change ownership:
`chown -R user:` /opt/mealie/

## Create containers directory

mkdir -p ~/.config/containers/systemd

copy files from either container/ or pod/

## Pod

create a random postgres password and store it as a podman secret.

'openssl rand -base64 64 | podman secret create mealie-db-password -'

