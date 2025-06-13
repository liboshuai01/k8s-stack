前提准备
---

无

安装应用
---

```shell
bash install.sh
```

验证应用
---

### 初步验证

```shell
bash status.sh
```

### 进阶验证

**1. 部署测试应用**
```shell
kubectl create -f https://raw.githubusercontent.com/apache/flink-kubernetes-operator/release-1.12/examples/basic.yaml -n flink
```

**2. 查看测试应用日志**
```shell
kubectl logs -f deploy/basic-example -n flink
```
> 日志中出现: `Completed checkpoint...`之类的内容，表示测试应用正常启动。

**3. 删除测试应用**
```shell
kubectl delete -f https://raw.githubusercontent.com/apache/flink-kubernetes-operator/release-1.12/examples/basic.yaml -n flink
```

更新应用
---

无

卸载应用
---

**1. 执行卸载脚本**

```shell
bash uninstall.sh
```

**2. （可选）完全删除**

```shell
kubectl delete ns flink
```
