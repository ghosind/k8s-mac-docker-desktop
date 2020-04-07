#!/bin/bash
#
# 根据不同版本自动获取Kubernetes启动所需镜像
# @author Chen Su <ghosind@gmail.com>

set -e

# 根据文件加载镜像
function pull_images() {
  if [ -f $1 ]
  then
    while IFS=":" read -r name image version
    do
      mirror_name=${name}_MIRROR
      source_name=${name}_SOURCE

      # 从镜像服务中拉取镜像
      docker pull ${!mirror_name}/$image:$version
      # 重新tag镜像，并删除镜像服务拉取的镜像
      docker tag ${!mirror_name}/$value ${!source_name}/$value
      docker rmi ${!mirror_name}/$value
    done < "$1"
  else
    echo $WARN_IMAGES_FILE
  fi
}

# 加载语言文件
LANGUAGE=${LANG:0:2}
if [ -f "/lang/$LANGUAGE.sh" ]
then
  source /lang/$LANGUAGE.sh
else
  source ./lang/zh.sh
fi

# 检查Docker是否安装
if [ ! -x "$(command -v docker)" ]
then
  echo $ERR_DOCKER
  exit 1
fi

# 获取Kubernetes版本
K8S_VERSION=$(kubectl version | cut -d "\"" -f 6 | head -n 1)

# 检查Kubernetes版本对应的镜像信息是否存在
dir="./images/$K8S_VERSION"
if [ ! -d $dir ]
then
  echo $ERR_K8S_VERSION
  exit 1
fi

# 检查镜像服务设置文件
mirror_file="mirrors.txt"
if ! [ -f "$mirror_file" ]
then
  echo $ERR_MIRROR_FILE
  exit 1
fi

# 加载镜像地址
while IFS="=" read -r name src mirror
do
  mirror_name=${name}_MIRROR
  if [ -z ${!mirror_name} ]
  then
    export ${name}_MIRROR=$mirror
  fi

  export ${name}_SOURCE=$src
done < "$mirror_file"

# 加载核心组件
pull_images "$dir/core.txt"

exit 0
