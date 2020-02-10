# k8s-mac-docker-desktop

针对国内无法直接从k8s.gcr.io上下载Kubernetes所需的镜像导致Docker Desktop for Mac无法开启Kubernets的问题。已于当前最新stable版（2.1.0.5）测试通过。默认情况下，脚本将从Azure提供的镜像服务器中下载所需镜像，也可设置`GCR_MIRROR`/`QUAY_MIRROR`变量指定镜像服务器（但注意其需要指定完整的路径，例如使用Azure的GCR镜像服务，需要设置为`gcr.azk8s.cn/google_containers`）。

## 特色

本项目拉取的镜像及其版本与阿里云的[k8s-for-docker-desktop](https://github.com/AliyunContainerService/k8s-for-docker-desktop)项目中保持一致，并在其基础上增加Kubernetes版本自动识别，以及可通过使用环境变量设置镜像服务地址等功能。

## 步骤

1. 使用`git clone https://github.com/ghosind/k8s-mac-docker-desktop.git`命令克隆至本地或直接下载代码压缩包；
2. 运行`load_images.sh`；
3. （可选）若需更改为其他镜像源，则可运行`GCR_MIRROR=<Mirror_Url> ./load_images.sh`；
4. 重启docker。

## 原理

国内无法直接从k8s.gcr.io上下载镜像，于是便先从镜像服务器上下载对应的镜像，在下载后重新tag至k8s.gcr.io上对应的tag。因kubernetes中部分镜像间有版本要求，便先运行`kubectl version`命令获取本地kubernetes版本，再下载对应相同版本的镜像（包括`kube-proxy`, `kube-controller-manager`, `kube-scheduler`, `kube-apiserver`）。

对于使用的镜像及其对应的版本，原版本中选择了最少的依赖镜像数量以及其经过测试后可用的最高版本，现改为与[AliyunContainerService/k8s-for-docker-desktop](https://github.com/AliyunContainerService/k8s-for-docker-desktop)保持一致。

## 支持Kubernetes版本

- v1.15.5
- v1.15.4
- v1.14.8
- v1.14.7
- v1.14.6
- v1.14.3
- v1.14.1
- v1.13.0
- v1.10.11

## TODO

- [ ] 增加Windows支持

## 致谢

- [AliyunContainerService/k8s-for-docker-desktop](https://github.com/AliyunContainerService/k8s-for-docker-desktop)
- [gotok8s/k8s-docker-desktop-for-mac](https://github.com/gotok8s/k8s-docker-desktop-for-mac)
