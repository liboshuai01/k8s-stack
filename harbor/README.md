前提准备
---

修改`.env`文件中配置的变量为自定义内容，如安装的命名空间、helm实例名称、char版本号等（可选）。

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
EXTERNAL-IP    harbor.lbs.com

> 示例
192.168.6.241  harbor.lbs.com
```

验证应用
---

### 初步验证

```shell
bash status.sh
```

### 进阶验证

1. 访问`http://harbor.lbs.com`，如果访问成功，则说明`harbor`安装成功。

更新应用
---

修改`.env`或`install.sh`文件中的内容，后重新执行`install.sh`脚本即可。

卸载应用
---

**1. 执行卸载脚本**

```shell
bash uninstall.sh
```

**2. （可选）删除pvc**

```shell
# 加载变量
source .env

# 查看pvc
kubectl get pvc -n ${NAMESPACE}

# 删除pvc（可能有多个pvc要删除）
kubectl delete pvc [pvc名称] -n ${NAMESPACE}
```

> 更详细的教程请查看：[K8s采用Helm部署harbor](https://lbs.wiki/pages/32b0bac/)
