# NzbGet Container
Starts an [NzbGet](http://nzbget.net/) instance. Requires the `nzbget-downloads` and `nzbget-nzbs` volumes and is started on port `6789`.
Configuration should be passed as additional parameters on starting the ACI.

**Example:**
```bash
rkt run aci.albertz.io/nzbget \
	--net=host \
	--volume nzbget-downloads,kind=host,source=/downloads \
	--volume nzbget-nzbs,kind=host,source=/nzbs \
	--volume resolv,kind=host,source=/etc/resolv.conf \
	--mount volume=resolv,target=/etc/resolv.conf \
 	-- \
	-o Server1.Host=news.provider.net \
	-o Server1.Port=789 \
	-o Server1.Encryption=yes \
	-o Server1.Connections=25 \
	-o Server1.Username=user \
	-o Server1.Password=pass
```

Note how we mounted our `resolv.conf` as well. Otherwise software inside the container cannot resolve the hostname.
