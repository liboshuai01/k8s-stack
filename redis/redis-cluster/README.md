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

**1. 首先，获取 Redis 密码 (假设 Release 名称为 redis-cluster，密码 Key 为 redis-password)**

```shell
export REDIS_PASSWORD=$(kubectl get secret --namespace "redis" my-redis-cluster -o jsonpath="{.data.redis-password}" | base64 -d)
```
   
**2. 启动一个临时的 Redis 客户端 Pod 来连接集群**

```shell
kubectl run --namespace redis my-redis-cluster-client --rm --tty -i --restart='Never' \
 --env REDIS_PASSWORD=$REDIS_PASSWORD \
--image docker.io/bitnami/redis-cluster:8.0.2-debian-12-r2 -- bash
```
   
**3. 在临时 Pod 中连接到 Redis 集群**

```shell
redis-cli -c -h my-redis-cluster -a $REDIS_PASSWORD
```

**4. 连接成功后，您可以执行 Redis 命令来验证集群状态**

```shell
# 在 redis-cli 提示符下执行
> info
> cluster nodes
```
   
**5. k8s 内部访问 Redis 集群**

```shell
# 方式一：<service>.<namespace>.svc.cluster.local:6379（大多数 Redis Cluster 客户端库只需要这个地址和密码即可自动发现所有节点）
my-redis-cluster.redis.svc.cluster.local:6379

# 方式二：<pod>.<headless-service>.<namespace>.svc.cluster.local:6379
my-redis-cluster-0.my-redis-cluster-headless.redis.svc.cluster.local:6379
my-redis-cluster-1.my-redis-cluster-headless.redis.svc.cluster.local:6379
my-redis-cluster-2.my-redis-cluster-headless.redis.svc.cluster.local:6379
my-redis-cluster-3.my-redis-cluster-headless.redis.svc.cluster.local:6379
my-redis-cluster-4.my-redis-cluster-headless.redis.svc.cluster.local:6379
my-redis-cluster-5.my-redis-cluster-headless.redis.svc.cluster.local:6379
```

### 监控验证

**1. 访问`prometheus`的`/targets`页面，查看`redis-exporter`是否正常 scrape metrics**

**2. 访问`grafana`并导入面板`11835`，查看`redis-exporter`的dashboard是否正常显示。**
    

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

> 更详细的教程请查看：[K8s采用Helm部署redis-cluster](https://lbs.wiki/pages/2a489a94/)
