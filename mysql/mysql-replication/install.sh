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
helm upgrade --install ${RELEASE_NAME} bitnami/mysql --version ${CHART_VERSION} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  \
  --set architecture=replication \
  --set-string global.storageClass="${STORAGE_CLASS_NAME}" \
  \
  --set-string auth.rootPassword="${MYSQL_ROOT_PASSWORD}" \
  --set-string auth.database="${MYSQL_DATABASE}" \
  --set-string auth.username="${MYSQL_USER}" \
  --set-string auth.password="${MYSQL_PASSWORD}" \
  --set-string auth.replicationUser="${MYSQL_REPLICATION_USERNAME}" \
  --set-string auth.replicationPassword="${MYSQL_REPLICATION_PASSWORD}" \
  \
  --set primary.persistence.size=16Gi \
  --set primary.resources.requests.cpu=250m \
  --set primary.resources.requests.memory=512Mi \
  --set primary.resources.limits.cpu=2000m \
  --set primary.resources.limits.memory=4096Mi \
  \
  --set secondary.replicaCount=${MYSQL_SECONDARY_REPLICAS} \
  --set secondary.persistence.size=16Gi \
  --set secondary.resources.requests.cpu=250m \
  --set secondary.resources.requests.memory=512Mi \
  --set secondary.resources.limits.cpu=2000m \
  --set secondary.resources.limits.memory=4096Mi \
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
