# Using Quadlet to Manage mealie

There are two options: 
    'mealie.container', which uses the internal SQLlite datebase. 
    Mealie Pod, which using postgres 17. THe Pod directory containers three files, mealie.pod, mealie-app.container and mealie-db.container. 

Regardless of which you use, I store all files in /opt/melalie. If you wish to use volumes, replace /opt/mealie/data and /opt/mealie/db with approiate volume names.

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


