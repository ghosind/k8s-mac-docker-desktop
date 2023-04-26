# k8s-mac-docker-desktop

![](https://github.com/ghosind/k8s-mac-docker-desktop/workflows/shellcheck/badge.svg)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/1eb7785707d84735bfa16ddd9c49b8f6)](https://www.codacy.com/gh/ghosind/k8s-mac-docker-desktop/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ghosind/k8s-mac-docker-desktop&amp;utm_campaign=Badge_Grade)

针对国内无法直接从k8s.gcr.io上下载Kubernetes所需的镜像导致Docker Desktop for Mac无法开启Kubernets的问题。默认情况下，脚本将从阿里云提供的镜像服务器中下载所需镜像，也可设置`GCR_MIRROR`/`QUAY_MIRROR`变量指定镜像服务器（但注意其需要指定完整的路径，例如使用阿里云的GCR镜像服务，需要设置为`registry.cn-hangzhou.aliyuncs.com/google_containers`）。

## 特色

- 自动识别Kubernetes版本
- 通过环境变量自定义镜像服务器
- 按需拉取核心服务、其他服务所需组件

## 步骤

1. 使用`git clone https://github.com/ghosind/k8s-mac-docker-desktop.git`命令克隆至本地或直接下载代码压缩包；
2. 运行`load_images.sh`；
3. （可选）若需更改为其他镜像源，则可运行`GCR_MIRROR=<Mirror_Url> ./load_images.sh`；
4. （可选）按需要拉取dashboard所需镜像（`./load_images.sh dashboard`）；
5. 重启docker。

## 原理

国内无法直接从k8s.gcr.io上下载镜像，于是便先从镜像服务器上下载对应的镜像，在下载后重新tag至k8s.gcr.io上对应的tag。因kubernetes中部分镜像间有版本要求，便先运行`kubectl version`命令获取本地kubernetes版本，再下载对应相同版本的镜像（包括`kube-proxy`, `kube-controller-manager`, `kube-scheduler`, `kube-apiserver`）。

## 支持Kubernetes版本

| k8s版本 | core | dashboard | 其他 |
|:------:|:----:|:---------:|:----:|
| v1.25.4 | O | X | |
| v1.25.2 | O | X | |
| v1.25.0 | O | X | |
| v1.24.0 | O | X | |
| v1.23.4 | O | X | |
| v1.22.5 | O | X | |
| v1.22.4 | O | X | |
| v1.21.5 | O | X | |
| v1.21.4 | O | X | |
| v1.21.3 | O | X | |
| v1.21.2 | O | X | |
| v1.21.1 | O | X | |
| v1.19.7 | O | X | |
| v1.19.3 | O | X | |
| v1.18.8 | O | X | |
| v1.18.6 | O | X | |
| v1.18.3 | O | X | |
| v1.16.5<br/>(v1.16.6-beta.0) | O | X | |
| v1.15.5 | √ | O | |
| v1.15.4 | O | O | |
| v1.14.8 | O | O | |
| v1.14.7 | O | O | |
| v1.14.6 | O | O | |
| v1.14.3 | O | O | |
| v1.14.1 | O | O | |
| v1.13.0 | O | O | |
| v1.10.11 | O | O | |

- `√` 已测试
- `O` 已支持未测试
- `X` 未支持

## 更新

- 2020-04-29: Azure镜像服务无法使用，更改为使用阿里云镜像服务

## TODO

- [X] 按需拉取部分所需组件
- [ ] 增加Windows支持

## 致谢

- [AliyunContainerService/k8s-for-docker-desktop](https://github.com/AliyunContainerService/k8s-for-docker-desktop)
- [gotok8s/k8s-docker-desktop-for-mac](https://github.com/gotok8s/k8s-docker-desktop-for-mac)
