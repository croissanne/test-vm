#!/bin/bash

set -e

CLOUD_IMAGE=$1

if [ -z "$CLOUD_IMAGE" ]; then
	echo "Usage:"
	echo "	$./run-instance.sh image.img"
	exit 1
fi

qemu-system-x86_64 \
    -nographic \
    -enable-kvm \
    -m 6144 \
    -cpu max \
    -smp 6 \
    -net nic,model=virtio \
    -net user,hostfwd=tcp::2222-:22,hostfwd=tcp::8085-:443,hostfwd=tcp::9091-:9090,hostfwd=tcp::8787-:8787 \
    $CLOUD_IMAGE
