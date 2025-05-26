#!/usr/bin/env bash

# 添加库并更新
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# --- 配置变量 ---
NAMESPACE="redis"
RELEASE_NAME="my-redis-exporter"
CHAR_VERSION="6.10.3"

# --- 安装/升级命令 ---
helm upgrade --install ${RELEASE_NAME} prometheus-community/prometheus-redis-exporter \
  --version ${CHAR_VERSION} --namespace ${NAMESPACE} --create-namespace \
  \
  --set redisAddress="redis://my-redis-cluster:6379" \
  \
  --set serviceMonitor.enabled=true \
  --set serviceMonitor.namespace=monitoring \
  --set serviceMonitor.labels.release="kube-prom-stack" \
  \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=1000m \
  --set resources.limits.memory=2048Mi \
  \
  --set auth.enabled=true \
  --set auth.secret.name="my-redis-cluster" \
  --set auth.secret.key="redis-password" \

echo ""
echo "${RELEASE_NAME} 安装/升级过程已启动到命名空间 '${NAMESPACE}'。"
echo "---------------------------------------------------------------------"
echo "监控 Pod 状态: kubectl get pods -n ${NAMESPACE} -w"
echo "---------------------------------------------------------------------"
