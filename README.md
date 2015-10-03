# A collection of app container image creation scripts
Simply run the `acis.sh` script. It will run the specified package from the `packages` directory and add them to a directory named `out` in your working directory:

	./acis.sh postgresql

In addition it will also generate the `pubkeys.gpg` in the same directory.

## Usage
```

Usage:

  acis.sh [-a|--arch] [-d|--docker] [(-t|--target) OUTDIR] [PACKAGES]...

Compiles the provided archci recipes and docker containers into aci containers. PACKAGES can be any number of names of the archci packages residing in "$PWD/packages"

Flags:
  -h|--help
      Show this help

  -a|--arch
      Compile all arch packages

  -d|--docker
      Compile all docker packages

  -t|--target OUTDIR
      Output all files to OUTDIR. Defaults to "$PWD/out"

```
