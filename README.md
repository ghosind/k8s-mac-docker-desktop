# k8s-mac-docker-desktop

针对国内无法直接从k8s.gcr.io上下载Kubernetes所需的镜像导致Docker Desktop for Mac无法开启Kubernets的问题。已于当前最新stable版（2.1.0.5）测试通过。默认情况下，脚本将从Azure提供的镜像服务器中下载所需镜像，也可设置`GCR_MIRROR`变量指定镜像服务器（但注意其需要指定完整的路径，例如使用Azure，需要设置为`gcr.azk8s.cn/google_containers`）。

## 步骤

1. 使用`git clone https://github.com/ghosind/k8s-mac-docker-desktop.git`命令克隆至本地或直接下载代码压缩包；
2. 运行`load_images.sh`；
3. （可选）若需更改为其他镜像源，则可运行`GCR_MIRROR=<Mirror_Url> ./load_images.sh`；
3. 重启docker。

## 原理

国内无法直接从k8s.gcr.io上下载镜像，于是便先从镜像服务器上下载对应的镜像，在下载后重新tag至k8s.gcr.io上对应的tag。因kubernetes中部分镜像间有版本要求，便先运行`kubectl version`命令获取本地kubernetes版本，再下载对应相同版本的镜像（包括`kube-proxy`, `kube-controller-manager`, `kube-scheduler`, `kube-apiserver`）。

在测试的过程中以及文档中发现对于`pause`及`coredns`没有严格的版本要求，于是便使用了当前最新的版本。对于`etcd`文档中提及到从kubernets 1.16起使用etcd v3.4（或3.3.14），而当前stable版的Docker内置的kubernetes版本为1.14.8，所以便使用了较早的3.3.10版。

## TODO

- 针对Edge版以后后续版本，拉取更新的`etcd`镜像。

## 致谢

- [gotok8s/k8s-docker-desktop-for-mac](https://github.com/gotok8s/k8s-docker-desktop-for-mac)
