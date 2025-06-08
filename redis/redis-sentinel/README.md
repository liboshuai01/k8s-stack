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

**1. 首先，获取 Redis 密码 (假设 Release 名称为 my-redis-sentinel，密码 Key 为 redis-password)**

```shell
export REDIS_PASSWORD=$(kubectl get secret --namespace redis my-redis-ha -o jsonpath="{.data.redis-password}" | base64 -d)
```
   
**2. 启动一个临时的 Redis 客户端 Pod 来连接实例**

```shell
kubectl run my-redis-sentinel-client --namespace redis --rm --tty -i \
--env REDIS_PASSWORD_ENV="$REDIS_PASSWORD" \
--image docker.io/bitnami/redis:8.0.2-debian-12-r3 \
-- bash
```
   
**3. 在临时 Pod 中连接到 Redis 实例**

```shell
# 连接到只读节点
redis-cli -h my-redis-ha -p 6379 -a "$REDIS_PASSWORD_ENV"
# 连接到哨兵节点
redis-cli -h my-redis-ha -p 26379 -a "$REDIS_PASSWORD_ENV"
```

**4. 连接成功后，您可以执行 Redis 命令来验证实例状态**

```shell
# 连接到只读节点后，在 redis-cli 提示符下执行
> info

# 连接到哨兵节点后，在 redis-cli 提示符下执行
> sentinel masters
> sentinel master mymaster
> sentinel slaves mymaster
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

> 更详细的教程请查看：[K8s采用Helm部署redis-sentinel实战指南](https://lbs.wiki/pages/5c36b781/)
