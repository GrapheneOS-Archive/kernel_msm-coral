#!/bin/bash

set -o errexit -o pipefail

[[ $# -eq 1 ]] || exit 1

DEVICE=$1

if [[ $DEVICE != coral && $DEVICE != sunfish && $DEVICE != flame ]]; then
    	echo invalid device codename
	exit 1
fi

if [[ $DEVICE != sunfish ]]; then
	DEVICE=floral
fi

KBUILD_BUILD_VERSION=1 KBUILD_BUILD_USER=grapheneos KBUILD_BUILD_HOST=grapheneos KBUILD_BUILD_TIMESTAMP="Thu 01 Jan 1970 12:00:00 AM UTC" BUILD_CONFIG=private/msm-google/build.config.$DEVICE build/build.sh

