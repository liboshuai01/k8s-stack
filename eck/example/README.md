前提准备
---

复制文件`values-example.yml`为`values.yml`，并根据需求修改配置内容。

安装应用
---

**1. 执行安装脚本**

```shell
bash install.sh
```

**2. 获取`ingress`的`EXTERNAL-IP`**

```shell
# EXTERNAL-IP 为 192.168.6.241
[lbs@master ingress-nginx]$ kubectl get svc -n ingress-nginx
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.43.51.133    192.168.6.241   80:32443/TCP,443:30784/TCP   26s
ingress-nginx-controller-admission   ClusterIP      10.43.230.20    <none>          443/TCP                      26s
ingress-nginx-controller-metrics     ClusterIP      10.43.141.155   <none>          10254/TCP                    26s
```

**3. 配置客户端机器`hosts`文件，添加一下内容**

```
> 格式
EXTERNAL-IP    kibana.lbs.com

> 示例
192.168.6.241  kibana.lbs.com
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
TMP_PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -n eck -o=jsonpath='{.data.elastic}' | base64 --decode)
```

**2. 启动临时 Pod，访问 kibana 登录页面（也可以使用浏览器）**
```shell
kubectl run es-health-check -n eck --rm -it --image=curlimages/curl --restart=Never \
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
kubectl get pvc -n eck

# 删除pvc（可能有多个pvc要删除）
kubectl delete pvc [pvc名称] -n eck
```
