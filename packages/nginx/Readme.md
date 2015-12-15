# Nginx Container
Starts an [nginx](http://nginx.org/) instance. Requires the `nginx-config` volume.
The ports are `80` and `443` under the names `nginx-http` and `nginx-https` respectively.

**Example:**
```bash
rkt run	aci.albertz.io/nginx \
	--net=host \
	--volume nginx-config,kind=host,source=/etc/nginx
```
