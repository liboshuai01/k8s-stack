#!/usr/bin/env bash

# --- 可配置变量 ---
HELM_RELEASE_NAME="redis-cluster"
NAMESPACE="redis-cluster"
CHART_VERSION="12.0.4" # Bitnami Redis Cluster Chart 版本，请按需选择
STORAGE_CLASS="nfs-storage" # 替换为您的 StorageClass 名称
REDIS_PASSWORD="YOUR_PASSWORD" # 替换为您的强密码
# ------------------

# 添加 Bitnami Helm 仓库 (如果已添加，此步骤会提示已存在)
helm repo add bitnami https://charts.bitnami.com/bitnami

# 更新本地 Helm 仓库索引
helm repo update

# 使用 Helm 安装 Redis Cluster
helm install "$HELM_RELEASE_NAME" bitnami/redis-cluster --version "$CHART_VERSION" \
  --namespace "$NAMESPACE" \
  --create-namespace \
  --set-string global.storageClass="$STORAGE_CLASS" \
  --set-string global.redis.password="$REDIS_PASSWORD"

  # --set cluster.nodes=6 # 默认3主3从，可以调整节点数
  # --set cluster.replicas=1 # 每个主节点的从节点数量

echo "Redis Cluster 安装命令已执行。请使用 status.sh 检查状态。"