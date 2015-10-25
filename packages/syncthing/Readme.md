# Syncthing Container
Starts a [syncthing](https://syncthing.net/) instance. Requires the `data` and `config` volumes. The data volume is mounted to `/srv/data`, so you should place any folders to be synced within this directory.
The default ports are used and named `syncthing-ui`, `syncthing-sync`, `syncthing-discovery-ipv4` and `syncthing-discovery-ipv6`.
