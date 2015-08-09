# Syncthing container
Starts a [syncthing](https://syncthing.net/) instance. Requires the `data` and `config` volumes. The data volume is mounted to `/srv/data`, so you should place any folders to be synced within this directory.
The config volume is used to persist configuration across restarts.
You should keep the ports set as they are, as the container only has the default ports configured.
