# Postgresql Container
Starts a [postgresql](http://www.postgresql.org/) instance. Requires the `postgres-data` volume.
The port is set to `5432` under the name `postgresql`.

On start, if the mounted volume is empty, the database will be initialized with locale `en_US.UTF-8`.

**Example:**
```bash
rkt run aci.albertz.io/postgresql \
	--volume postgres-data,kind=host,source=/opt/postgresql \
	--net=host
```
