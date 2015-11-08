# aci-discovery Container
Starts an [aci-discovery](https://github.com/coreos/aci-discovery) instance. Requires the `aci-discovery-images` volume and is started on port `80`.

**Example:**
```bash
rkt run aci.albertz.io/aci-discovery \
	--volume aci-discovery-images,kind=host,source=/srv/acis/out \
	--net=host \
	-- \
	--domain=aci.albertz.io
```
