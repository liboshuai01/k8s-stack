#!/usr/bin/env bash

# --- 加载变量 ---
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# 添加库并更新
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# --- 安装命令 ---
helm upgrade --install ${RELEASE_NAME} prometheus-community/prometheus-kafka-exporter \
  --version ${CHART_VERSION} --namespace ${NAMESPACE} --create-namespace \
  \
  --set kafkaServer[0]="${KAFKA_SERVER}" \
  --set prometheus.serviceMonitor.enabled=true \
  --set prometheus.serviceMonitor.namespace="${MONITOR_NAMESPACE}" \
  --set prometheus.serviceMonitor.additionalLabels.release="${MONITOR_RELEASE_NAME}" \
  \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=1000m \
  --set resources.limits.memory=2048Mi
