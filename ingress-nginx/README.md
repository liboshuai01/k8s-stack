前提准备
---

1. 确保`k8s`集群中的各节点中的`80/443`端口均没有被占用。
2. 如果应该存在了其他`ingress controller`请先卸载，下面为卸载`traefik`的示例命令。
    ```shell
    helm uninstall traefik -n kube-system
    helm uninstall traefik-crd -n kube-system
    ```
3. 修改`.env`文件中配置的变量为自定义内容，如安装的命名空间、helm实例名称、char版本号等（可选）。

安装应用
---

**1. 执行安装脚本**

```shell
bash install.sh
```

**2. 给对应节点打调度标签**

执行完`install.sh`脚本后，请手动执行下面的命令选择指定节点让`ingress controller`调度到对应的节点。
```shell
kubectl label node [节点名称] ingress=true --overwrite

# 例如
# kubectl label node k8s-node-1 ingress=true --overwrite
```

验证应用
---

### 初步验证

```shell
bash status.sh
```
   
### 进阶验证

**1. 进一步验证，可以创建一个测试应用，并使用`ingress`访问**

```shell
helm upgrade --install nginx-test-app bitnami/nginx \
  --version 20.0.3 --namespace default \
  \
  --set service.type=ClusterIP \
  \
  --set ingress.enabled=true \
  --set ingress.ingressClassName=nginx \
  --set ingress.hostname="nginx.lbs.com" \
  --set ingress.path="/" \
  \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=250m \
  --set resources.limits.memory=512Mi
```
   
**2. 配置`hosts`文件，添加一下内容**

```
[任意ingress-nginx节点IP]    nginx.lbs.com

# 例如
# 192.168.6.202    nginx.lbs.com
```
   
**3. 访问`nginx.lbs.com`，如果访问成功，则说明安装成功**
   
**4. 测试成功后，删除测试应用**

```shell
helm uninstall nginx-test-app -n default
```

更新应用
---

修改`.env`或`install.sh`文件中的内容，后重新执行`install.sh`脚本即可。

卸载应用
---

**1. 执行卸载脚本**

```shell
bash uninstall.sh
```

**2. （可选）将`ingress`标签从节点上删除**

```shell
kubectl label node [节点名称] ingress-

# 例如
kubectl label node k8s-node-1 ingress-
```

> 更详细的教程请查看：[K8s采用Helm部署ingress-nginx](https://lbs.wiki/pages/ad80c258/)
