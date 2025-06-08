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
helm upgrade --install "${RELEASE_NAME}" bitnami/redis \
  --version "${CHART_VERSION}" --namespace "${NAMESPACE}" --create-namespace \
  \
  --set architecture=standalone \
  \
  --set-string global.redis.password="${REDIS_PASSWORD}" \
  \
  --set master.persistence.enabled=true \
  --set-string master.persistence.storageClass="${STORAGE_CLASS_NAME}" \
  --set master.persistence.size=8Gi \
  \
  --set master.resources.requests.cpu=100m \
  --set master.resources.requests.memory=128Mi \
  --set master.resources.limits.cpu=512m \
  --set master.resources.limits.memory=2048Mi \
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
