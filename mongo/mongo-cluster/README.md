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
export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace mongo my-mongo-cluster-mongodb -o jsonpath="{.data.mongodb-root-password}" | base64 -d)
```

**2. 启动MongoDB客户端Pod**

```shell
kubectl run --namespace mongo my-mongo-cluster-mongodb-client --rm --tty -i --restart='Never' --env="MONGODB_ROOT_PASSWORD=$MONGODB_ROOT_PASSWORD" --image docker.io/bitnami/mongodb:8.0.10-debian-12-r1 --command -- bash
```

**3. 连接MongoDB**

```shell
mongosh admin --host "my-mongo-cluster-mongodb-0.my-mongo-cluster-mongodb-headless.mongo.svc.cluster.local:27017,my-mongo-cluster-mongodb-1.my-mongo-cluster-mongodb-headless.mongo.svc.cluster.local:27017,my-mongo-cluster-mongodb-2.my-mongo-cluster-mongodb-headless.mongo.svc.cluster.local:27017" --authenticationDatabase admin -u root -p $MONGODB_ROOT_PASSWORD
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
# 加载变量
source .env

# 查看pvc
kubectl get pvc -n ${NAMESPACE}

# 删除pvc（可能有多个pvc要删除）
kubectl delete pvc [pvc名称] -n ${NAMESPACE}
```

> 更详细的教程请查看：[K8s采用Helm部署mysql-cluster实战指南](https://lbs.wiki/pages/a668abcf/)
