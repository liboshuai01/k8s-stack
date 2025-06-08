#!/usr/bin/env bash

set -e

# --- 加载变量 ---
if [ -f .env ]; then
    # shellcheck disable=SC1091
    source .env
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# --- 添加仓库并更新 ---
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# --- 安装 / 升级 ---
helm upgrade --install ${RELEASE_NAME} bitnami/mongodb --version ${CHART_VERSION} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  \
  --set architecture=replicaset \
  --set replicaCount=${REPLICA_COUNT} \
  --set replicaSetName="${MONGO_REPLICA_SET_NAME}" \
  --set-string global.storageClass="${STORAGE_CLASS_NAME}" \
  \
  --set-string auth.replicaSetKey="${MONGO_REPLICA_SET_KEY}" \
  --set-string auth.rootPassword="${MONGO_ROOT_PASSWORD}" \
  --set-string auth.databases[0]="${MONGO_DATABASE}" \
  --set-string auth.usernames[0]="${MONGO_USER}" \
  --set-string auth.passwords[0]="${MONGO_PASSWORD}" \
  \
  --set podAntiAffinityPreset=hard \
  \
  --set persistence.size=16Gi \
  \
  --set resources.requests.cpu=250m \
  --set resources.requests.memory=512Mi \
  --set resources.limits.cpu=1000m \
  --set resources.limits.memory=2048Mi \
  \
  --set metrics.enabled=true \
  --set metrics.serviceMonitor.enabled=true \
  --set metrics.serviceMonitor.namespace="${PROMETHEUS_NAMESPACE}" \
  --set metrics.serviceMonitor.labels.release="${PROMETHEUS_RELEASE_LABEL}"
