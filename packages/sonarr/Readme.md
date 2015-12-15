# Sonarr Container
Starts an [sonarr](https://sonarr.tv/) instance. Requires the `sonarr-config` volume.
The port is `8989` under the name `sonarr`.

**Example:**
```bash
rkt run	aci.albertz.io/sonarr \
	--net=host \
	--volume sonarr-config,kind=host,source=/etc/sonarr \
```
