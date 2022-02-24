#!/bin/bash
#
# 根据不同版本自动获取Kubernetes启动所需镜像
# @author Chen Su <ghosind@gmail.com>

set -e

# 根据文件加载镜像
pull_images() {
  if [ -f "$1" ]
  then
    while IFS=":" read -r name image version
    do
      mirror_name="${name}_MIRROR"
      source_name="${name}_SOURCE"

      if [ "$version" = "K8S_VERSION" ]
      then
        version="$K8S_VERSION"
      fi

      # 从镜像服务中拉取镜像
      docker pull "${!mirror_name}/$image:$version"
      # 重新tag镜像，并删除镜像服务拉取的镜像
      docker tag "${!mirror_name}/$image:$version" "${!source_name}/$image:$version"
      docker rmi "${!mirror_name}/$image:$version"
    done < "$1"
  else
    echo "$WARN_IMAGES_FILE"
  fi
}

# 加载语言文件
LANGUAGE=${LANG:0:2}
if [ -f "./lang/$LANGUAGE.sh" ]
then
  # shellcheck disable=SC1090
  source "./lang/$LANGUAGE.sh"
else
  # shellcheck disable=SC1091
  source "./lang/zh.sh"
fi

if [ $# -gt 1 ]
then
  echo "$ERR_INVALID_PARAMS"
  exit 1
fi

# 确定加载的镜像类别
# 默认情况加载核心模块
module="core"
K8S_NO_DEFAULT="false"
while [ "$#" -gt "0" ]
do
  case "$1" in
  core | dashboard )
    module="$1"
    ;;
  -h)
    echo "$INFO_HELP"
    exit 0
    ;;
  -d)
    set -x
    ;;
  -n)
    K8S_NO_DEFAULT="true"
    ;;
  *)
    K8S_VERSION="$1"
    ;;
  esac
  shift
done

# 检查Docker是否安装
if [ ! -x "$(command -v docker)" ]
then
  echo "$ERR_DOCKER"
  exit 1
fi

if [ -z "$K8S_VERSION" ]
then
  # 获取Kubernetes版本
  K8S_VERSION=$(kubectl version 2>/dev/null | cut -d "\"" -f 6 | head -n 1)
fi

# 检查Kubernetes版本对应的镜像信息是否存在
dir="./images/$K8S_VERSION"
if [ ! -d "$dir" ]
then
  if [ ! -f "./images/default/$module.txt" ] || [ "$K8S_NO_DEFAULT" = "true" ]
  then
    echo "$ERR_K8S_VERSION"
    exit 1
  fi
  dir="./images/default"
fi

# 检查镜像服务设置文件
mirror_file="mirrors.txt"
if ! [ -f "$mirror_file" ]
then
  echo "$ERR_MIRROR_FILE"
  exit 1
fi

# 加载镜像地址
while IFS="=" read -r name src mirror
do
  mirror_name="${name}_MIRROR"
  if [ -z "${!mirror_name}" ]
  then
    export "${mirror_name}"="${mirror}"
  fi

  export "$name"_SOURCE="$src"
done < "$mirror_file"

# 加载指定模块镜像
pull_images "$dir/$module.txt"

exit 0
