#!/usr/bin/env bash

# --- 加载变量 ---
if [ -f .env ]; then
    export $(grep -v '^#' .env | sed 's/\r$//' | xargs)
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# --- 添加仓库并更新 ---
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# --- 安装 / 升级 ---
helm upgrade --install ${RELEASE_NAME} bitnami/kafka --version ${CHART_VERSION} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  \
  --set-string global.defaultStorageClass="${STORAGE_CLASS_NAME}" \
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
  --set defaultInitContainers.prepareConfig.resources.limits.cpu=250m \
  --set defaultInitContainers.prepareConfig.resources.limits.memory=512Mi \
  \
  --set controller.replicaCount=3 \
  --set controller.persistence.enabled=true \
  --set controller.persistence.size=16Gi \
  --set controller.logPersistence.enabled=true \
  --set controller.logPersistence.size=4Gi \
  --set controller.resources.requests.cpu=250m \
  --set controller.resources.requests.memory=512Mi \
  --set controller.resources.limits.cpu=1000m \
  --set controller.resources.limits.memory=2048Mi
  # 如果需要分离的 Broker 节点 (KRaft 提供的 Dedicated Broker Mode)，请取消注释并配置以下参数 \
  # --set broker.replicaCount=3 \
  # --set broker.persistence.enabled=true \
  # --set broker.persistence.size=32Gi \
  # --set broker.logPersistence.enabled=true \
  # --set broker.logPersistence.size=8Gi \
  # --set broker.resources.requests.cpu=250m \
  # --set broker.resources.requests.memory=512Mi \
  # --set broker.resources.limits.cpu=1000m \
  # --set broker.resources.limits.memory=2048Mi \
