前提准备
---

复制文件`.env.example`为`.env`，复制文件`values-example.yml`为`values.yml`，并根据需求修改配置内容。

安装应用
---

**1. 执行安装脚本**

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

通过查看`eck-operator`的 Pod 日志，可以验证 Operator 是否正常运行。

```shell
# 加载 .env 文件中的变量
source .env

# 查看 Pod 状态
kubectl get pods -n ${NAMESPACE}

# 查看 Operator 日志
kubectl logs -f -n ${NAMESPACE} $(kubectl get pods -n ${NAMESPACE} -l control-plane=elastic-operator -o name)
```

当您看到类似 "Starting reconciliation" 或 "Successfully reconciled" 的日志时，说明 Operator 已成功启动并正在工作。

更新应用
---

修改`.env`、`values.yml`文件内容后，重新执行`install.sh`脚本即可。

卸载应用
---

**1. 执行卸载脚本**

```shell
bash uninstall.sh
```
