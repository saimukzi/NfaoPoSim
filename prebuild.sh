#!/bin/bash -e

TIMESTAMP=`date +%s`
GIT_HASH=`git rev-parse HEAD`
GIT_STATUS_WC=`git status -s | grep -v ^$ | wc -l`
if [[ "${GIT_STATUS_WC}" == "0" ]];then
  GIT_CLEAN="true"
else
  GIT_CLEAN="false"
fi

echo TIMESTAMP=${TIMESTAMP}
echo GIT_HASH=${GIT_HASH}
echo GIT_CLEAN=${GIT_CLEAN}

export TIMESTAMP
export GIT_HASH
export GIT_CLEAN

cat version/version.gd.template | envsubst > version/version.gd
