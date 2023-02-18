# Mealie Pod

I have both shell script and kubernetes yaml. 

The yaml and shell scripts will both create a pod called mealie with two containers called mealie-api and mealie-frontend.



## Mealie podman shell script

There are currently two shell scripts. One for Mealie beta-5 and one for nightly.

The podman shell script is stright forward. The script will create a pod called mealie which you can connect to from host through port 10006.

Two containers will be created called mealie-api and mealie-frontend.

SMTP and LDAP has not been enabled.

### Updating shell script

This is only true for beta. it is not true for nightly.

Until Mealie gets out of beta, you will have to manually update the containers.

Edit the mealie.sh file and change, `hkotel/mealie:frontend-v1.0.0beta-5` and 
to `hkotel/mealie:frontend-v1.0.0beta-6` for example.

stop the Mealie pod

```bash:
podman pod stop mealie
```

Rerun the `mealie.sh` script. Because we are using `--replace` flag, the pod 
and containers should automatically be replaced with the updated containers.

## Mealie yaml

### If you convert shell script to yaml

It is important to note, mealie-frontend enviroment variable `API_URL` is the name of mealie-api container. The shell script creates a container call mealie-api. Converting it using `podman generate kube` generates a name that combines the pod name with the container name, `mealie-mealie-api`. This breaks Mealie. `mealie=frontend` cannot find `mealie-api`.

In the yaml script, you will either have to edit `API_URL` value to `mealie-mealie-api:9000` or change the container name to `api`.
