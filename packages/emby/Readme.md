# Emby Container
Starts an [emby](https://emby.media/) instance. Requires the `emby-data` and `emby-media` volumes.
The ports are `8096` and `8945` under the names `emby-ui` and `emby-websocket` respectively.

**Example:**
```bash
rkt run	aci.albertz.io/emby \
	--net=host \
	--volume emby-data,kind=host,source=/etc/emby \
	--volume emby-media,kind=host,source=/srv/media \
	--volume resolv,kind=host,source=/etc/resolv.conf \
	--mount volume=resolv,target=/etc/resolv.conf \
```

Note how we mounted our `resolv.conf` as well. Otherwise software inside the container cannot resolve any hostnames.
