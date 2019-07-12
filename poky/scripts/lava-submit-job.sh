#!/bin/sh

set -e

if [ "$CI_COMMIT_REF_NAME" != "master" ]; then
	exit 0
fi

PATH=$PATH:~/.local/bin

if ! which lavacli 2>&1 >/dev/null; then
	echo "Installing lavacli..."
	pip3 install lavacli
fi

JOB=$1

# add token
lavacli identities add --token $LAVA_TOKEN --uri https://lava.ciplatform.org/RPC2 --username sangorrind default

echo "Submitting job $JOB"
lavacli jobs submit $JOB


