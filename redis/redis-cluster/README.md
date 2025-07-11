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

**2. 获取 Redis 密码**

```shell
REDIS_PASSWORD=$(kubectl get secret --namespace ${NAMESPACE} ${RELEASE_NAME} -o jsonpath="{.data.redis-password}" | base64 -d)
```
   
**3. 启动一个临时的 Redis 客户端 Pod 来连接集群**

```shell
kubectl run --namespace ${NAMESPACE} ${RELEASE_NAME}-client --rm --tty -i --restart='Never' \
 --env NAMESPACE=$NAMESPACE \
 --env RELEASE_NAME=$RELEASE_NAME \
 --env REDIS_PASSWORD=$REDIS_PASSWORD \
--image docker.io/bitnami/redis-cluster:8.0.2-debian-12-r2 -- bash
```
   
**4. 在临时 Pod 中连接到 Redis 集群**

```shell
redis-cli -c -h ${RELEASE_NAME}.${NAMESPACE}.svc.cluster.local -a $REDIS_PASSWORD
```

**5. 连接成功后，您可以执行 Redis 命令来验证集群状态**

```shell
# 在 redis-cli 提示符下执行
> info
> cluster nodes
```

### 监控验证

**1. 访问`prometheus`的`/targets`页面，查看`redis-exporter`是否正常 scrape metrics**

**2. 访问`grafana`并导入面板`11835`，查看`redis-exporter`的dashboard是否正常显示。**
    

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

```shell
方式一
---
> 格式
<service>.<namespace>.svc.cluster.local:6379
> 示例
my-redis-cluster.redis.svc.cluster.local:6379

方式二
---
> 格式
<pod>.<headless-service>.<namespace>.svc.cluster.local:6379
> 示例
my-redis-cluster-0.my-redis-cluster-headless.redis.svc.cluster.local:6379
my-redis-cluster-1.my-redis-cluster-headless.redis.svc.cluster.local:6379
my-redis-cluster-2.my-redis-cluster-headless.redis.svc.cluster.local:6379
my-redis-cluster-3.my-redis-cluster-headless.redis.svc.cluster.local:6379
my-redis-cluster-4.my-redis-cluster-headless.redis.svc.cluster.local:6379
my-redis-cluster-5.my-redis-cluster-headless.redis.svc.cluster.local:6379
```

> 更详细的教程请查看：[K8s采用Helm部署redis-cluster](https://lbs.wiki/pages/2a489a94/)
