#!/usr/bin/env bash

# --- 加载变量 ---
if [ -f .env ]; then
    source .env
else
    echo "错误: .env 文件不存在! 请先创建 .env 文件。"
    exit 1
fi

# --- 添加仓库并更新 ---
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# --- 安装 / 升级 ---
helm upgrade --install ${RELEASE_NAME} prometheus-community/prometheus-mysql-exporter \
  --version ${CHART_VERSION} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  \
  --set mysql.host="${MYSQL_HOST}" \
  --set mysql.user="${MYSQL_USER}" \
  --set mysql.existingPasswordSecret.name="${MYSQL_SECRET_NAME}" \
  --set mysql.existingPasswordSecret.key="${MYSQL_SECRET_KEY}" \
  \
  --set serviceMonitor.enabled=true \
  --set serviceMonitor.namespace="${MONITOR_NAMESPACE}" \
  --set serviceMonitor.additionalLabels.release="${MONITOR_RELEASE_NAME}" \
  \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=200m \
  --set resources.limits.memory=256Mi
