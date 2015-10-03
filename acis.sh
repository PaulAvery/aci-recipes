#!/bin/bash
set -e

# Setup
ARCH=()
DOCKER=()
ACIDIR="$(pwd)/out"
BUILDDIR=$(mktemp -d)

function printUsage() {
	echo
	echo 'Usage:'
	echo
	echo '  acis.sh [-a|--arch] [-d|--docker] [(-t|--target) OUTDIR] [PACKAGES]...'
	echo
	echo 'Compiles the provided archci recipes and docker containers into aci containers. PACKAGES can be any number of names of the archci packages residing in "$PWD/packages"'
	echo
	echo 'Flags:'
	echo '  -h|--help'
	echo '      Show this help'
	echo
	echo '  -a|--arch'
	echo '      Compile all arch packages'
	echo
	echo '  -d|--docker'
	echo '      Compile all docker packages'
	echo
	echo '  -t|--target OUTDIR'
	echo '      Output all files to OUTDIR. Defaults to "$PWD/out"'
	echo
}

function cleanup() {
	echo
	echo "Cleaning Up"

	# Clean up
	sudo rm -rf "$BUILDDIR"

	echo "Done"
}

function printInfo() {
	if [ ! ${#ARCH[@]} -eq 0 ] || [ ! ${#DOCKER[@]} -eq 0 ]; then
		echo "Outputting the following packages to \"$ACIDIR\":"

		if [ ! ${#ARCH[@]} -eq 0 ]; then
			echo
			echo "  Arch:"
			for i in "${ARCH[@]}"; do
				echo "    $i"
			done
		fi

		if [ ! ${#DOCKER[@]} -eq 0 ]; then
			echo
			echo "  Docker:"
			for i in "${DOCKER[@]}"; do
				echo "    $i"
			done
		fi

		echo
	fi
}

function buildArch() {
	if [ ! ${#ARCH[@]} -eq 0 ]; then
		for PACKAGE in "${ARCH[@]}"; do
			echo "Building Arch Package \"$PACKAGE\""
			archci "packages/$PACKAGE" "$BUILDDIR" > /dev/null
		done

		echo
	fi
}

function buildDocker() {
	if [ ! ${#DOCKER[@]} -eq 0 ]; then
		cd $BUILDDIR
		for PACKAGE in "${DOCKER[@]}"; do
			echo "Building Docker Package \"$PACKAGE\""
			docker2aci "docker://$PACKAGE" "$BUILDDIR" > /dev/null
		done
		cd - > /dev/null

		echo
	fi
}

function finalize() {
	echo "Outputting GPG Key to \"$ACIDIR/pubkeys.gpg\""

	# Create gpg key
	gpg --export > "$BUILDDIR/pubkeys.gpg"

	# Copy packages to target directory after setting permissions
	sudo chmod -R 644 "$BUILDDIR"
	sudo chmod -R a+X "$BUILDDIR"
	sudo chown -R root:root "$BUILDDIR"

	sudo cp -rp "$BUILDDIR"/* "$ACIDIR"
}

# Run cleanup on error
trap cleanup EXIT

# Parse arguments
while [[ $# > 0 ]]; do
	arg="$1"

	case $arg in
		-h|--help)
			printUsage
			exit 0
			;;
		-t|--target)
			ACIDIR="$2"
			shift
			;;
		-d|--docker)
			readarray -t DOCKER < 'packages/docker'
			;;
		-a|--arch)
			cd packages
			shopt -s nullglob
			ARCH=(*/)
			shopt -u nullglob
			cd - > /dev/null
			;;
		*)
			ARCH+=("$1")
		;;
	esac

	shift
done

# Run all this stuff
printInfo
buildArch
buildDocker
finalize
