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
helm upgrade --install "${RELEASE_NAME}" bitnami/redis-cluster \
  --version "${CHART_VERSION}" --namespace "${NAMESPACE}" --create-namespace \
  --set-string global.storageClass="${STORAGE_CLASS_NAME}" \
  --set-string global.redis.password="${REDIS_PASSWORD}" \
  \
  --set persistence.size=8Gi \
  \
  --set redis.resources.requests.cpu=100m \
  --set redis.resources.requests.memory=128Mi \
  --set redis.resources.limits.cpu=1024m \
  --set redis.resources.limits.memory=2048Mi \
  \
  --set updateJob.resources.requests.cpu=100m \
  --set updateJob.resources.requests.memory=128Mi \
  --set updateJob.resources.limits.cpu=1024m \
  --set updateJob.resources.limits.memory=2048Mi \
  \
  --set rbac.create=true \
  \
  --set metrics.enabled=true \
  --set metrics.serviceMonitor.enabled=true \
  --set metrics.serviceMonitor.namespace="${PROMETHEUS_NAMESPACE}" \
  --set metrics.serviceMonitor.labels.release="${PROMETHEUS_RELEASE_LABEL}" \
  --set metrics.resources.requests.cpu=100m \
  --set metrics.resources.requests.memory=128Mi \
  --set metrics.resources.limits.cpu=256m \
  --set metrics.resources.limits.memory=1024Mi
