#!/usr/bin/env bash

# 添加 Bitnami Helm 仓库并更新
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# 安装 Kafka 集群
helm install kafka-cluster bitnami/kafka --version 32.2.6 \
  --namespace kafka-cluster \
  --create-namespace \
  --set-string global.defaultStorageClass="nfs-storage" \
  --set listeners.client.protocol=PLAINTEXT \
  --set listeners.client.sslClientAuth=none \
  --set listeners.controller.protocol=PLAINTEXT \
  --set listeners.controller.sslClientAuth=none \
  --set listeners.interbroker.protocol=PLAINTEXT \
  --set listeners.interbroker.sslClientAuth=none \
  --set listeners.external.protocol=PLAINTEXT \
  --set listeners.external.sslClientAuth=none \
  --set controller.replicaCount=3 \
  --set controller.persistence.enabled=true \
  --set controller.persistence.size=16Gi \
  --set controller.logPersistence.enabled=true \
  --set controller.logPersistence.size=8Gi \
  --set metrics.jmx.enabled=true
  # 如果需要分离的 Broker 节点 (KRaft 提供的 Dedicated Broker Mode)，请取消注释并配置以下参数
  # --set broker.replicaCount=3 \
  # --set broker.persistence.enabled=true \
  # --set broker.persistence.size=16Gi \
  # --set broker.logPersistence.enabled=true \
  # --set broker.logPersistence.size=8Gi \

echo "Kafka cluster installation process initiated."
echo "Use 'kubectl get pods -n kafka-cluster -w' to monitor pod status."
echo "Or use './status.sh' to check all resources in the namespace."
