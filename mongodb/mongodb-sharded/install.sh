#!/usr/bin/env bash

set -e
set -o pipefail

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

# --- 安装 / 升级 MongoDB Sharded Cluster ---
helm upgrade --install ${RELEASE_NAME} bitnami/mongodb-sharded --version ${CHART_VERSION} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  \
  --set-string global.defaultStorageClass="${STORAGE_CLASS_NAME}" \
  --set auth.enabled=true \
  --set-string auth.rootPassword="${MONGO_ROOT_PASSWORD}" \
  --set-string auth.replicaSetKey="${MONGO_REPLICA_SET_KEY}" \
  \
  --set shards=${SHARD_COUNT} \
  \
  --set mongos.replicaCount=${MONGOS_REPLICA_COUNT} \
  --set mongos.podAntiAffinityPreset=soft \
  --set mongos.resources.requests.cpu=100m \
  --set mongos.resources.requests.memory=128Mi \
  --set mongos.resources.limits.cpu=512m \
  --set mongos.resources.limits.memory=2048Mi \
  \
  --set configsvr.replicaCount=${CONFIGSVR_REPLICA_COUNT} \
  --set configsvr.podAntiAffinityPreset=soft \
  --set configsvr.persistence.enabled=true \
  --set configsvr.persistence.size=8Gi \
  --set configsvr.resources.requests.cpu=100m \
  --set configsvr.resources.requests.memory=128Mi \
  --set configsvr.resources.limits.cpu=512m \
  --set configsvr.resources.limits.memory=2048Mi \
  \
  --set shardsvr.dataNode.replicaCount=${SHARDSVR_REPLICA_COUNT} \
  --set shardsvr.dataNode.podAntiAffinityPreset=soft \
  --set shardsvr.persistence.enabled=true \
  --set shardsvr.persistence.size=16Gi \
  --set shardsvr.dataNode.resources.requests.cpu=100m \
  --set shardsvr.dataNode.resources.requests.memory=128Mi \
  --set shardsvr.dataNode.resources.limits.cpu=512m \
  --set shardsvr.dataNode.resources.limits.memory=2048Mi \
  \
  --set metrics.enabled=true \
  --set metrics.serviceMonitor.enabled=true \
  --set metrics.serviceMonitor.namespace="${PROMETHEUS_NAMESPACE}" \
  --set metrics.serviceMonitor.labels.release="${PROMETHEUS_RELEASE_LABEL}" \
  --set metrics.resources.requests.cpu=100m \
  --set metrics.resources.requests.memory=128Mi \
  --set metrics.resources.limits.cpu=256m \
  --set metrics.resources.limits.memory=1024Mi \
  \
  --set extraEnvVars[0].name=TZ \
  --set extraEnvVars[0].value=Asia/Shanghai
