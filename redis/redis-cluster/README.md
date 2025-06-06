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

**1. 首先，获取 Redis 密码 (假设 Release 名称为 redis-cluster，密码 Key 为 redis-password)**

```shell
export REDIS_PASSWORD=$(kubectl get secret --namespace redis my-redis-cluster -o jsonpath="{.data.redis-password}" | base64 --decode)
echo "Redis Password: $REDIS_PASSWORD"
```
   
**2. 启动一个临时的 Redis 客户端 Pod 来连接集群**

```shell
kubectl run redis-client --namespace redis --rm --tty -i \
--env REDIS_PASSWORD_ENV="$REDIS_PASSWORD" \
--image docker.io/bitnami/redis-cluster:7.0.15 \
-- bash
```
   
**3. 在临时 Pod 中连接到 Redis 集群**

```shell
# 在 redis-client Pod 内部执行（my-redis-cluster为clusterIP类型的service）
redis-cli -c -h my-redis-cluster -a "$REDIS_PASSWORD_ENV"
```

**4. 连接成功后，您可以执行 Redis 命令来验证集群状态**

```shell
# 在 redis-cli 提示符下执行
> cluster info
# 期望看到: cluster_state:ok, cluster_slots_assigned:16384, cluster_size:3 (主节点数), ...

> cluster nodes
# 期望看到: 列出所有节点的信息，及其角色和连接状态。

> set mykey "Hello K8s Redis Cluster"
# > GET mykey
# "Hello K8s Redis Cluster"

> exit
```
   
**5. k8s 集群内部访问直接通过 service 访问 Redis 集群**

> 大多数 Redis Cluster 客户端库只需要这个地址和密码即可自动发现所有节点。

格式为：`<service>.<namespace>.svc.cluster.local`，例如：`my-redis-cluster.redis.svc.cluster.local`。
    

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

> 更详细的教程请查看：[K8s采用Helm部署redis-cluster实战指南](https://lbs.wiki/pages/5c36b781/)
