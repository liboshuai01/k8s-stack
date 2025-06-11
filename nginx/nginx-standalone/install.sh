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
helm upgrade --install ${RELEASE_NAME} bitnami/nginx \
  --version ${CHART_VERSION} --namespace ${NAMESPACE} --create-namespace \
  \
  --set replicaCount=1 \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=512m \
  --set resources.limits.memory=2048Mi \
  \
  --set service.type=${SERVICE_TYPE} \
  \
  --set ingress.enabled=${INGRESS_ENABLED} \
  --set ingress.ingressClassName=${INGRESS_CLASS_NAME} \
  --set ingress.hostname=${NGINX_HOST} \
  --set ingress.path="/" \
  \
  --set cloneStaticSiteFromGit.gitSync.resources.requests.cpu=100m \
  --set cloneStaticSiteFromGit.gitSync.resources.requests.memory=128Mi \
  --set cloneStaticSiteFromGit.gitSync.resources.limits.cpu=256m \
  --set cloneStaticSiteFromGit.gitSync.resources.limits.memory=1024Mi \
  \
  --set metrics.enabled=true \
  --set metrics.serviceMonitor.enabled=true \
  --set metrics.serviceMonitor.namespace="${PROMETHEUS_NAMESPACE}" \
  --set metrics.serviceMonitor.labels.release="${PROMETHEUS_RELEASE_LABEL}" \
  --set metrics.resources.requests.cpu=100m \
  --set metrics.resources.requests.memory=128Mi \
  --set metrics.resources.limits.cpu=256m \
  --set metrics.resources.limits.memory=1024Mi
