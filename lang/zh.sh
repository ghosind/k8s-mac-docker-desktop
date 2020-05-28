#!/bin/bash

# 警告信息
export WARN_IMAGES_FILE="WARN: 对应镜像服务文件不存在"

# 错误信息
export ERR_INVALID_PARAMS="ERR: 参数数量错误"
export ERR_BAD_OPTION="ERR: 无效的可选参数"
export ERR_DOCKER="ERR: 必须安装Docker"
export ERR_K8S_VERSION="ERR: 未知Kubernetes版本"
export ERR_MIRROR_FILE="ERR: 镜像信息文件不存在"

# 帮助信息
export INFO_HELP="获取Kubernetes所需镜像
使用方法: ./load_images.sh [core|dashboard|-d|-h|<k8s版本>]

可选项:
-d Debug模式（显式命令）
-h 输出帮助信息
core 加载Kubernetes核心镜像
dashboard 加载Kubernetes dashboard所需镜像

环境变量:
GCR_MIRROR gcr.io镜像地址
QUAY_MIRROR quay.io镜像地址"
