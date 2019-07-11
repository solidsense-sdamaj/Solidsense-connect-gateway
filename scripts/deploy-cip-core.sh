#!/bin/sh

set -e

if [ "$CI_COMMIT_REF_NAME" != "master" ]; then
	exit 0
fi

PATH=$PATH:~/.local/bin

if ! which aws 2>&1 >/dev/null; then
	echo "Installing awscli..."
	pip3 install wheel
	pip3 install awscli
fi

TARGET=$1
DTB=$2

echo "Uploading artifacts..."
aws s3 cp --no-progress build/tmp/deploy/images/$TARGET/core-image-minimal-$TARGET.tar.gz s3://download.cip-project.org/cip-core/deby/$TARGET/

KERNEL_IMAGE=build/tmp/deploy/images/$TARGET/uImage
aws s3 cp --no-progress $KERNEL_IMAGE s3://download.cip-project.org/cip-core/deby/$TARGET/

if [ -n "$DTB" ]; then
	aws s3 cp --no-progress build/tmp/deploy/images/$TARGET/uImage-$DTB s3://download.cip-project.org/cip-core/$TARGET/$DTB
fi
