#!/bin/bash
#
# 根据不同版本自动获取Kubernetes启动所需镜像
# @author Chen Su <ghosind@gmail.com>

set -e

# 检查Docker是否安装
if [ ! -x "$(command -v docker)" ]
then
  echo "ERR: 必须安装Docker"
  exit 1
fi

# 获取Kubernetes版本
K8S_VERSION=$(kubectl version | cut -d "\"" -f 6 | head -n 1)

# 检查Kubernetes版本对应的镜像信息是否存在
dir="./images/$K8S_VERSION"
if [ ! -d $dir ]
then
  echo "ERR: 未知Kubernetes版本"
  exit 1
fi

# 检查镜像服务设置文件
mirror_file="mirrors.txt"
if ! [ -f "$mirror_file" ]
then
  echo "ERR: 镜像信息文件不存在"
  exit 1
fi

while IFS="=" read -r name source mirror
do
  mirror_name=${name}_MIRROR

  # 根据全局变量获取镜像服务地址
  if [ -z ${!mirror_name} ]
  then
    # 当全局变量不存在是使用默认的镜像服务地址
    mirror_address=$mirror
  else
    mirror_address=${!mirror_name}
  fi

  file="$dir/$(tr '[:upper:]' '[:lower:]' <<< $name).txt"

  if [ -f $file ]
  then
    while read -r value
    do
      docker pull $mirror_address/$value
      docker tag $mirror_address/$value $source/$value
      docker rmi $mirror_address/$value
    done < "$file"
  else
    echo "WARN: 对应镜像文件不存在"
    continue
  fi
done < "$mirror_file"

exit 0
