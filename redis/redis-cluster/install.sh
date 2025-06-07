#!/usr/bin/env bash

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
helm upgrade --install "${RELEASE_NAME}" bitnami/redis-cluster \
  --version "${CHART_VERSION}" --namespace "${NAMESPACE}" --create-namespace \
  --set-string global.storageClass="${STORAGE_CLASS_NAME}" \
  --set-string global.redis.password="${REDIS_PASSWORD}" \
  \
  --set persistence.size=6Gi \
  \
  --set redis.resources.requests.cpu=250m \
  --set redis.resources.requests.memory=512Mi \
  --set redis.resources.limits.cpu=1000m \
  --set redis.resources.limits.memory=2048Mi \
  \
  --set updateJob.resources.requests.cpu=250m \
  --set updateJob.resources.requests.memory=512Mi \
  --set updateJob.resources.limits.cpu=1000m \
  --set updateJob.resources.limits.memory=2048Mi \
  \
  --set metrics.enabled=true \
  --set metrics.serviceMonitor.enabled=true \
  --set metrics.serviceMonitor.namespace="${PROMETHEUS_NAMESPACE}" \
  --set metrics.serviceMonitor.labels.release="${PROMETHEUS_RELEASE_LABEL}"
