#!/bin/bash
set -e
ACIDIR=$1

if [ -z $ACIDIR ]; then
	echo 'Please specify a target directory'
	exit 1
fi

# Build all packages
BUILDDIR=$(mktemp -d)
for file in packages/*; do
	archci "$file" "$BUILDDIR"
	echo
done

# Create gpg key
gpg --export > "$BUILDDIR/pubkeys.gpg"

# Copy them to target directory after setting permissions
sudo chmod -R 644 "$BUILDDIR"
sudo chmod -R a+X "$BUILDDIR"
sudo chown -R root:root "$BUILDDIR"

sudo cp -rp "$BUILDDIR"/* "$ACIDIR"

# Clean up
sudo rm -rf "$BUILDDIR"
