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
mkdir $TARGET
cp build/tmp/deploy/images/$TARGET/core-image-minimal-$TARGET.tar.gz ./$TARGET/
cp build/tmp/deploy/images/$TARGET/uImage ./$TARGET/
if [ -n "$DTB" ]; then
    cp build/tmp/deploy/images/$TARGET/uImage-$DTB ./$TARGET/$DTB
fi
aws s3 sync $TARGET/. s3://download.cip-project.org/cip-core/deby/ --acl public-read
rm -rf $TARGET