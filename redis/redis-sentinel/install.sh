#!/usr/bin/env bash

# --- 加载变量 ---
if [ -f .env ]; then
    source .env
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# --- 添加仓库并更新 ---
echo "添加并更新 Bitnami Helm 仓库..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# --- 安装 / 升级 ---
echo "开始部署 Redis (一主${REPLICA_COUNT}从, ${REPLICA_COUNT}哨兵)..."
helm upgrade --install "${RELEASE_NAME}" bitnami/redis \
  --version "${CHART_VERSION}" --namespace "${NAMESPACE}" --create-namespace \
  \
  --set-string global.redis.password="${REDIS_PASSWORD}" \
  \
  --set architecture=replication \
  \
  --set master.persistence.enabled=true \
  --set-string master.persistence.storageClass="${STORAGE_CLASS_NAME}" \
  --set master.persistence.size=6Gi \
  --set master.resources.requests.cpu=250m \
  --set master.resources.requests.memory=512Mi \
  --set master.resources.limits.cpu=1000m \
  --set master.resources.limits.memory=2048Mi \
  \
  --set replica.replicaCount=${REPLICA_COUNT} \
  --set replica.persistence.enabled=true \
  --set-string replica.persistence.storageClass="${STORAGE_CLASS_NAME}" \
  --set replica.persistence.size=6Gi \
  --set replica.resources.requests.cpu=250m \
  --set replica.resources.requests.memory=512Mi \
  --set replica.resources.limits.cpu=1000m \
  --set replica.resources.limits.memory=2048Mi \
  \
  --set sentinel.enabled=true \
  --set sentinel.quorum=${SENTINEL_QUORUM} \
  --set sentinel.getMasterTimeout=10 \
  --set rbac.create=true \
  --set-string serviceAccount.name="redis-sentinel-sa" \
  \
  --set metrics.enabled=true \
  --set metrics.serviceMonitor.enabled=true \
  --set metrics.serviceMonitor.namespace="${PROMETHEUS_NAMESPACE}" \
  --set metrics.serviceMonitor.additionalLabels.release="${PROMETHEUS_RELEASE_LABEL}"
