前提准备
---

**1. 首先安装`cert-manager`**
```shell
kubectl create -f cert-manager.yaml
kubectl get all -n cert-manager
```

> 安装`cert-manger`等待所有pod处于running后，再多等待一会哦，不然直接部署flink-operator会报错！

安装应用
---

```shell
helm repo add flink-operator-repo https://downloads.apache.org/flink/flink-kubernetes-operator-1.12.0/
helm repo update
helm install flink-kubernetes-operator flink-operator-repo/flink-kubernetes-operator -n flink --create-namespace
```

验证应用
---

### 初步验证

```shell
kubectl get all -n flink
```

### 进阶验证

**1. 部署测试应用**
```shell
kubectl create -f ./examples/basic.yaml -n flink
```

**2. 查看测试应用日志**
```shell
kubectl logs -f deploy/basic-example -n flink
```
> 日志中出现: `Completed checkpoint...`之类的内容，表示测试应用正常启动。

**3. 删除测试应用**
```shell
kubectl delete -f ./examples/basic.yaml -n flink
```

更新应用
---

先卸载旧operator，然后安装新的operator。

卸载应用
---

**1. 卸载operator**

```shell
helm uninstall flink-kubernetes-operator -n flink
```

**2. 卸载cert-manager**

```shell
kubectl delete -f cert-manager.yaml
```

**3. 删除命名空间（可选）**

```shell
kubectl delete ns flink
```
