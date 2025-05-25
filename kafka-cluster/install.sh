#!/usr/bin/env bash

# 添加 Bitnami Helm 仓库并更新
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# --- 配置变量 ---
# Kafka 安装相关
KAFKA_RELEASE_NAME="kafka-cluster"
KAFKA_NAMESPACE="kafka-cluster"
KAFKA_CHART_VERSION="32.2.8" # 请确认这是您希望使用的稳定版本 (与你提供的 values.yaml 对应)
STORAGE_CLASS="nfs-storage"

# --- 安装 Kafka 集群 ---
helm install ${KAFKA_RELEASE_NAME} bitnami/kafka --version ${KAFKA_CHART_VERSION} \
  --namespace ${KAFKA_NAMESPACE} \
  --create-namespace \
  \
  --set-string global.defaultStorageClass="${STORAGE_CLASS}" \
  \
  --set listeners.client.protocol=PLAINTEXT \
  --set listeners.client.sslClientAuth=none \
  --set listeners.controller.protocol=PLAINTEXT \
  --set listeners.controller.sslClientAuth=none \
  --set listeners.interbroker.protocol=PLAINTEXT \
  --set listeners.interbroker.sslClientAuth=none \
  --set listeners.external.protocol=PLAINTEXT \
  --set listeners.external.sslClientAuth=none \
  \
  --set defaultInitContainers.prepareConfig.resources.requests.cpu=100m \
  --set defaultInitContainers.prepareConfig.resources.requests.memory=128Mi \
  --set defaultInitContainers.prepareConfig.resources.limits.cpu=150m \
  --set defaultInitContainers.prepareConfig.resources.limits.memory=192Mi \
  \
  --set controller.replicaCount=3 \
  --set controller.persistence.enabled=true \
  --set controller.persistence.size=16Gi \
  --set controller.logPersistence.enabled=true \
  --set controller.logPersistence.size=4Gi \
  --set controller.resources.requests.cpu=500m \
  --set controller.resources.requests.memory=1024Mi \
  --set controller.resources.limits.cpu=750m \
  --set controller.resources.limits.memory=1536Mi \
  # 如果需要分离的 Broker 节点 (KRaft 提供的 Dedicated Broker Mode)，请取消注释并配置以下参数 \
  # --set broker.replicaCount=3 \
  # --set broker.persistence.enabled=true \
  # --set broker.persistence.size=32Gi \
  # --set broker.logPersistence.enabled=true \
  # --set broker.logPersistence.size=8Gi \
  # --set broker.resources.requests.cpu=500m \
  # --set broker.resources.requests.memory=1024Mi \
  # --set broker.resources.limits.cpu=750m \
  # --set broker.resources.limits.memory=1536Mi \

echo ""
echo "Kafka 集群 (${KAFKA_RELEASE_NAME}) 安装/升级过程已启动到命名空间 '${KAFKA_NAMESPACE}'。"
echo "---------------------------------------------------------------------"
echo "监控 Pod 状态: kubectl get pods -n ${KAFKA_NAMESPACE} -w"
echo "---------------------------------------------------------------------"
