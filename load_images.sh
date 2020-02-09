#!/bin/bash

set -e

if [ ! -x "$(command -v docker)" ]
then
  echo "Docker must be installed."
  exit 1
fi

K8S_VERSION=$(kubectl version | cut -d "\"" -f 6 | head -n 1)

if [ -z $G $GCR_MIRROR ]
then
  GCR_MIRROR=gcr.azk8s.cn/google_containers
fi

if [ -z $G $QUAY_MIRROR ]
then
  QUAY_MIRROR=quay.azk8s.cn
fi

file="./images/${K8S_VERSION}.txt"

if [ -f $file ]
then
  while read -r value
  do
    docker pull $GCR_MIRROR/$value
    docker tag $GCR_MIRROR/$value k8s.gcr.io/$value
    docker rmi $GCR_MIRROR/$value
  done < "$file"
else
  echo "Unknown kubernetes version."
  exit 1
fi

exit 0
