前提准备
---

修改`.env`文件中配置的变量为自定义内容，如安装的命名空间、helm实例名称、char版本号等（可选）。

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

**1. 获取root用户密码**

```shell
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace mysql my-mysql-standalone -o jsonpath="{.data.mysql-root-password}" | base64 -d)
```

**2. 启动MySQL客户端Pod**

```shell
kubectl run my-mysql-standalone-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.37-debian-12-r2 --namespace mysql --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash
```

**3. 连接MySQL**

```shell
mysql -h my-mysql-standalone.mysql.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"
```

**4. k8s 内部访问 MySQL 实例**

```shell
# <service>.<namespace>.svc.cluster.local:3306
my-mysql-standalone.mysql.svc.cluster.local:3306
```

### 监控验证

**1. 访问`prometheus`的`/targets`页面，查看`mysql-exporter`是否正常 scrape metrics**

**2. 访问`grafana`并导入面板`14057`，查看`mysql-exporter`的dashboard是否正常显示。**

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

> 更详细的教程请查看：[K8s采用Helm部署mysql-standalone实战指南](https://lbs.wiki/pages/a668abcf/)
