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

**1. 启动客户端 Pod**

```shell
# 请根据您helm install输出的NOTES部分提供的镜像名和标签进行调整
kubectl run kafka-test-client --rm --tty -i --restart='Never' --image docker.io/bitnami/kafka:4.0.0-debian-12-r3 --namespace kafka --command -- bash
```
    
**2. 进入客户端 Pod 的 shell**

```shell
kubectl exec --tty -i kafka-test-client --namespace kafka -- bash
```
    
**3. 在客户端 Pod 内，创建一个测试topic**

```shell
# 修改`my-kafka-standalone:9092`为您的kafka-standalone的bootstrap地址
kafka-topics.sh \
    --create \
    --bootstrap-server my-kafka-standalone:9092 \
    --topic test_topic \
    --partitions 3 \
    --replication-factor 1 # 对于1节点的combined mode-standalone，副本因子最大为1
```
    
**4. 在客户端 Pod 内，启动生产者发送消息**

```shell
# 修改`my-kafka-standalone:9092`为您的kafka-standalone的bootstrap地址
kafka-console-producer.sh \
    --bootstrap-server my-kafka-standalone:9092 \
    --topic test_topic
```
输入消息: `>Hello Kafka from New Script`

**5. 在客户端 Pod 内，启动消费者接收消息 (新开一个终端执行 kubectl exec...)**

```shell
# 修改`my-kafka-standalone:9092`为您的kafka-standalone的bootstrap地址
kafka-console-consumer.sh \
    --bootstrap-server my-kafka-standalone:9092 \
    --topic test_topic \
    --from-beginning
```
你应该能看到发送的消息。

**6. k8s 内部访问 Kafka 实例**

```shell
# <pod>.<headless-service>.<namespace>.svc.cluster.local:9092
my-redis-standalone-master-0.my-redis-standalone-headless.redis.svc.cluster.local:6379
```

### 监控验证

**1. 访问`prometheus`的`/targets`页面，查看`kafka-exporter`是否正常 scrape metrics**

**2. 访问`grafana`并导入面板`7589`，查看`kafka-exporter`的dashboard是否正常显示。**

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

> 更详细的教程请查看：[K8s采用Helm部署Kafka-standalone实战指南](https://lbs.wiki/pages/84c192a2/)
