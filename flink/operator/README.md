前提准备
---

**1. 首先安装k8s集群中安装了`cert-manager`**

> 安装`cert-manger`等待所有pod处于running后，再多等待一会哦，不然直接部署flink-operator会报错！

**2. 复制文件`.env.example`为`.env`，复制文件`values-example.yml`为`values.yml`，并根据需求修改配置内容。**

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
kubectl create -f ./basic.yaml -n flink
```

**2. 查看测试应用日志**

> 等待一会儿，Flink应用部署成功后，再进行日志查看。

```shell
kubectl logs -f deploy/basic-example -n flink
```
> 刚开始为`Failed to trigger checkpoint for job ......`，多等待一会儿。
> 
> 若后续日志中出现: `Completed checkpoint...`之类的内容，则表示测试应用正常启动。

**3. 删除测试应用**
```shell
kubectl delete -f ./basic.yaml -n flink
```

更新应用
---

先执行`uninstall.sh`脚本卸载旧的operator，然后修改`.env`、`values.yml`文件，最后执行`install.sh`脚本安装新的operator。

卸载应用
---

**1. 执行卸载脚本**

```shell
bash uninstall.sh
```

**2. [可选] 删除命名空间**

```shell
kubectl delete ns flink
```
