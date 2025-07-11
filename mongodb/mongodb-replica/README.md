前提准备
---

复制文件`.env.example`为`.env`，复制文件`values-example.yml`为`values.yml`，并根据需求修改配置内容。

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

**1. 加载环境变量**

```shell
source .env
```

**2. 获取root用户密码**

```shell
export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace ${NAMESPACE} ${RELEASE_NAME} -o jsonpath="{.data.mongodb-root-password}" | base64 -d)
```

**3. 启动MongoDB客户端Pod**

```shell
kubectl run --namespace ${NAMESPACE} ${RELEASE_NAME}-client --rm --tty -i --restart='Never' \
--env NAMESPACE=${NAMESPACE} \
--env RELEASE_NAME=${RELEASE_NAME} \
--env MONGODB_ROOT_PASSWORD=${MONGODB_ROOT_PASSWORD} \
--image docker.io/bitnami/mongodb:8.0.10-debian-12-r1 --command -- bash
```

**4. 连接MongoDB**

```shell
mongosh admin --host \
"${RELEASE_NAME}-0.${RELEASE_NAME}-headless.${NAMESPACE}.svc.cluster.local:27017,${RELEASE_NAME}-1.${RELEASE_NAME}-headless.${NAMESPACE}.svc.cluster.local:27017,${RELEASE_NAME}-2.${RELEASE_NAME}-headless.${NAMESPACE}.svc.cluster.local:27017" \
--authenticationDatabase admin -u root -p $MONGODB_ROOT_PASSWORD
```

### 监控验证

**1. 访问`prometheus`的`/targets`页面，查看`mongodb-exporter`是否正常 scrape metrics**

**2. 访问`grafana`并导入面板`12079`或`20867`，查看`mongodb-exporter`的dashboard是否正常显示。**

更新应用
---

修改`.env`、`values.yml`文件内容后，重新执行`install.sh`脚本即可。

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

## 如何访问

```markdown
副本集名称
---
> values.yml配置项
MONGO_REPLICA_SET_NAME
> 示例
rs0

mongodb地址
---
复制集名称
---
> 配置项
replicaSetName
> 示例
rs0

地址
---
> 格式
<pod>.<headless-service>.<namespace>.svc.cluster.local:27017
> 示例
my-mongodb-replica-0.my-mongodb-replica-headless.mongodb.svc.cluster.local:27017
my-mongodb-replica-1.my-mongodb-replica-headless.mongodb.svc.cluster.local:27017
my-mongodb-replica-2.my-mongodb-replica-headless.mongodb.svc.cluster.local:27017
```

> 更详细的教程请查看：[K8s采用Helm部署mongodb-replica](https://lbs.wiki/pages/9d2481ad/)
