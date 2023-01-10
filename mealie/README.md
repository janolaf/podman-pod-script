# Melaie Pod

Until Mealie gets out of beta, you will have to manually update the containers.

Edit the mealie.sh file and change, `hkotel/mealie:frontend-v1.0.0beta-5` and 
to `hkotel/mealie:frontend-v1.0.0beta-6` for example.

stop the Mealie pod

```bash:
podman pod stop mealie
```

Rerun the `mealie.sh` script. Because we are using `--replace` flag, the pod 
and containers should automatically be replaced with the updated containers.

