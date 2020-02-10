#!/bin/bash

set -e

if [ ! -x "$(command -v docker)" ]
then
  echo "Docker must be installed."
  exit 1
fi

K8S_VERSION=$(kubectl version | cut -d "\"" -f 6 | head -n 1)

dir="./images/$K8S_VERSION"

if [ ! -d $dir ]
then
  echo "Unknown kubernetes version."
  exit 1
fi

if [ -z $G $GCR_MIRROR ]
then
  GCR_MIRROR=gcr.azk8s.cn/google_containers
fi

if [ -z $G $QUAY_MIRROR ]
then
  QUAY_MIRROR=quay.azk8s.cn
fi

sources=(
  GCR
)

for source in ${sources[@]}
do
  mirror_name=${source}_MIRROR
  mirror=${!mirror_name}
  file="$dir/$(tr '[:upper:]' '[:lower:]' <<< $source).txt"

  if [ -z $mirror ]
  then
    echo "Invalid $source mirror address"
    continue
  fi

  if [ -f $file ]
  then
    while read -r value
    do
      docker pull $mirror/$value
      docker tag $mirror/$value k8s.gcr.io/$value
      docker rmi $mirror/$value
    done < "$file"
  else
    continue
  fi
done

exit 0
