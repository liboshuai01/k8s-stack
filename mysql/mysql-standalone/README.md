前提准备
---

修改`.env`文件中配置的变量为自定义内容，如安装的命名空间、helm实例名称、char版本号等（可选）。

安装应用
---

```shell
bash install.sh
```

初步验证
---

```shell
bash status.sh
```

进阶验证
---

**1. 获取root用户密码**

```shell
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace mysql-standalone my-mysql-standalone -o jsonpath="{.data.mysql-root-password}" | base64 -d)
```

**2. 启动MySQL客户端Pod**

```shell
kubectl run my-mysql-standalone-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.37-debian-12-r2 --namespace mysql-standalone --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash
```

**3. 连接MySQL**

```shell
mysql -h my-mysql-standalone.mysql-standalone.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"
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

**2. （可选）删除pvc**

```shell
# 查看pvc
kubectl get pvc -n [namespace名称]

# 删除pvc
kubectl delete pvc [pvc名称] -n [namespace名称]
```

> 更详细的教程请查看：[K8s采用Helm部署mysql-standalone实战指南](https://lbs.wiki/pages/a668abcf/)