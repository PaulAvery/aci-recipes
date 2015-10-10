#!/bin/bash
set -e
set -o pipefail

# Setup
ARCH=()
DOCKER=()
ACIDIR="$(pwd)/out"
BUILDDIR=$(mktemp -d)
VERBOSE=false

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
	echo '  -v|--verbose'
	echo '      Print more output'
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
	rm -rf "$BUILDDIR"

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

			if [ "$VERBOSE" == "true" ]; then
				archci "packages/$PACKAGE" "$BUILDDIR"
			else
				archci "packages/$PACKAGE" "$BUILDDIR" > /dev/null
			fi
		done

		echo
	fi
}

function buildDocker() {
	if [ ! ${#DOCKER[@]} -eq 0 ]; then
		cd $BUILDDIR
		for PACKAGE in "${DOCKER[@]}"; do
			echo "Building Docker Package \"$PACKAGE\""
			FILE=$(docker2aci "docker://$PACKAGE" "$BUILDDIR" | sed -n '$p')

			MOS=$(tar -xOf "$FILE" manifest | sx -jx x.labels | sx -jxlf 'x.name === "os"' | sx -jx x.value)
			MARCH=$(tar -xOf "$FILE" manifest | sx -jx x.labels | sx -jxlf 'x.name === "arch"' | sx -jx x.value)
			MNAME=$(tar -xOf "$FILE" manifest | sx -jx 'x.name.split("/").pop()')
			MVERSION=$(tar -xOf "$FILE" manifest | sx -jx x.labels | sx -jxlf 'x.name === "version"' | sx -jx x.value)

			mkdir -p "images/$MOS/$MARCH"
			mv "$FILE" "images/$MOS/$MARCH/$MNAME-$MVERSION.aci"
		done
		cd - > /dev/null

		echo
	fi
}

function finalize() {
	echo "Outputting GPG Key to \"$ACIDIR/pubkeys.gpg\""

	# Create gpg key
	gpg --export > "$BUILDDIR/pubkeys.gpg"

	# Copy packages to target directory
	mkdir -p "$ACIDIR"
	cp -rp "$BUILDDIR"/* "$ACIDIR"
}

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
		-v|--verbose)
			VERBOSE=true
			;;
		*)
			ARCH+=("$1")
		;;
	esac

	shift
done

for i in "${ARCH[@]}"; do
	if [ ! -d "$(pwd)/packages/$i" ]; then
		echo "Package '$i' not found!"
		exit 1
	fi
done

# Run cleanup on error
trap cleanup EXIT

# Run all this stuff
printInfo
buildArch
buildDocker
finalize
