#!/usr/bin/env bash

set -e

# --- 加载变量 ---
if [ -f .env ]; then
    source .env
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
  --set defaultInitContainers.prepareConfig.resources.limits.memory=1024Mi \
  \
  --set controller.replicaCount=1 \
  --set controller.persistence.enabled=true \
  --set controller.persistence.size=16Gi \
  --set controller.logPersistence.enabled=true \
  --set controller.logPersistence.size=4Gi \
  --set controller.resources.requests.cpu=100m \
  --set controller.resources.requests.memory=128Mi \
  --set controller.resources.limits.cpu=512m \
  --set controller.resources.limits.memory=2048Mi \
  \
  --set rbac.create=true \
  \
  --set metrics.jmx.enabled=true \
  --set metrics.serviceMonitor.enabled=true \
  --set metrics.serviceMonitor.namespace="${NAMESPACE}" \
  --set metrics.serviceMonitor.selector.release="${PROMETHEUS_RELEASE_LABEL}" \
  --set metrics.resources.requests.cpu=100m \
  --set metrics.resources.requests.memory=128Mi \
  --set metrics.resources.limits.cpu=256m \
  --set metrics.resources.limits.memory=1024Mi
