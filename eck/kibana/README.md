前提准备
---

复制文件`values-example.yml`为`values.yml`，并根据需求修改配置内容。

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

**1. 获取`elastic`用户密码**
```shell
TMP_PASSWORD=$(kubectl get secret my-es-cluster-es-elastic-user -n elastic-system -o=jsonpath='{.data.elastic}' | base64 --decode)
```

**2. 启动临时 Pod，访问 kibana 登录页面（也可以使用浏览器）**
```shell
kubectl run es-health-check -n elastic-system --rm -it --image=curlimages/curl --restart=Never \
-- curl -Lku "elastic:${TMP_PASSWORD}" "https://my-kibana-kb-http:5601"
```

更新应用
---

修改`values.yml`文件内容后，重新执行`install.sh`脚本即可。

卸载应用
---

**1. 执行卸载脚本**

```shell
bash uninstall.sh
```

**2. （可选）删除 PVC**

```shell
# 查看pvc
kubectl get pvc -n elastic-system

# 删除pvc（可能有多个pvc要删除）
kubectl delete pvc [pvc名称] -n elastic-system
```
