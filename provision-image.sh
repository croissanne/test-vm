#!/bin/bash

set -e

OUTPUTDIR=$1

if [ -z "$OUTPUTDIR" ]; then
        echo "Usage:"
        echo "  $./provision-image.sh <output dir>"
	echo
	echo "Example:"
        echo "  $./provision-image.sh images/ f31"
        exit 1
fi

OUTPUTDIR=$(realpath "${OUTPUTDIR}")
DISTRO="fedora-41"
DVER="${DISTRO#fedora-}"
URL="https://fedora.cu.be/linux/releases/$DVER/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-$DVER-1.4.x86_64.qcow2"
IMAGE="$DISTRO.qcow2"

mkdir -p "${OUTPUTDIR}"
curl -L "${URL}" -o "${OUTPUTDIR}/${IMAGE}.partial"
qemu-img resize "${OUTPUTDIR}/${IMAGE}.partial" 80G
genisoimage \
        -quiet \
	-input-charset utf-8 \
	-output cloudinit.iso \
	-volid cidata \
	-joliet \
	-rock \
	ci-provision

mv "${OUTPUTDIR}/${IMAGE}.partial" "${OUTPUTDIR}/${IMAGE}"

qemu-img create \
         -o backing_file="$DISTRO".qcow2,backing_fmt=qcow2 -f qcow2 \
         "$OUTPUTDIR/$DISTRO"-overlay.qcow2
