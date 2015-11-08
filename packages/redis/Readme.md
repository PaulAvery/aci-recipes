# Redis Container
Starts a [redis](http://redis.io/) instance. Requires the `redis-config` volume.
The port is set to `6379` under the name `redis`.

If on start the config volume is empty, a `redis.conf` will be created.

**Example:**
```bash
rkt run aci.albertz.io/redis \
	--volume redis-config,kind=host,source=/opt/redis \
	--net=host
```
