#!/usr/bin/env bash

# --- 加载变量 ---
if [ -f .env ]; then
    export $(grep -v '^#' .env | sed 's/\r$//' | xargs)
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# --- 添加仓库并更新 ---
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# --- 安装 / 升级 ---
helm upgrade --install "${RELEASE_NAME}" prometheus-community/prometheus-redis-exporter \
  --version "${CHAR_VERSION}" --namespace "${NAMESPACE}" --create-namespace \
  \
  --set redisAddress="${REDIS_ADDRESS}" \
  \
  --set serviceMonitor.enabled=true \
  --set serviceMonitor.namespace="${MONITOR_NAMESPACE}" \
  --set serviceMonitor.labels.release="${MONITOR_RELEASE_NAME}" \
  \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=1000m \
  --set resources.limits.memory=2048Mi \
  \
  --set auth.enabled=true \
  --set auth.secret.name="${REDIS_SECRET_NAME}" \
  --set auth.secret.key="${REDIS_SECRET_KEY}"
