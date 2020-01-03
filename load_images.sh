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

images=(
  kube-proxy:$K8S_VERSION
  kube-controller-manager:$K8S_VERSION
  kube-scheduler:$K8S_VERSION
  kube-apiserver:$K8S_VERSION
  coredns:1.3.1
  pause:3.1
  etcd:3.3.10
)

for image in ${images[@]}
do
  docker pull $GCR_MIRROR/$image
  docker tag $GCR_MIRROR/$image k8s.gcr.io/$image
  docker rmi $GCR_MIRROR/$image
done

exit 0
