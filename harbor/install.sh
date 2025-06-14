#!/usr/bin/env bash

set -e
set -o pipefail

# --- 加载变量 ---
if [ -f .env ]; then
    source .env
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# --- 添加 Bitnami Helm 仓库并更新 ---
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# --- 安装 / 升级 Harbor ---
helm upgrade --install ${RELEASE_NAME} bitnami/harbor \
  --version ${CHART_VERSION} --namespace ${NAMESPACE} --create-namespace \
  \
  --set-string global.defaultStorageClass=${STORAGE_CLASS_NAME} \
  \
  --set externalURL="https://${HARBOR_HOST}" \
  --set adminPassword=${HARBOR_ADMIN_PASSWORD} \
  --set logLevel=info \
  \
  --set exposureType=ingress \
  --set ingress.core.ingressClassName=${INGRESS_CLASS_NAME} \
  --set ingress.core.hostname=${HARBOR_HOST} \
  \
  --set persistence.persistentVolumeClaim.registry.size=32Gi \
  \
  --set persistence.persistentVolumeClaim.jobservice.size=1Gi \
  \
  --set persistence.persistentVolumeClaim.trivy.size=5Gi \
  \
  --set postgresql.auth.postgresPassword=${HARBOR_DATABASE_PASSWORD} \
  \
  --set certificateVolume.resources.requests.cpu=100m \
  --set certificateVolume.resources.requests.memory=128Mi \
  --set certificateVolume.resources.limits.cpu=256m \
  --set certificateVolume.resources.limits.memory=1024Mi \
  \
  --set nginx.resources.requests.cpu=100m \
  --set nginx.resources.requests.memory=128Mi \
  --set nginx.resources.limits.cpu=256m \
  --set nginx.resources.limits.memory=1024Mi \
  \
  --set portal.resources.requests.cpu=100m \
  --set portal.resources.requests.memory=128Mi \
  --set portal.resources.limits.cpu=256m \
  --set portal.resources.limits.memory=1024Mi \
  \
  --set core.resources.requests.cpu=100m \
  --set core.resources.requests.memory=128Mi \
  --set core.resources.limits.cpu=256m \
  --set core.resources.limits.memory=1024Mi \
  \
  --set jobservice.resources.requests.cpu=100m \
  --set jobservice.resources.requests.memory=128Mi \
  --set jobservice.resources.limits.cpu=256m \
  --set jobservice.resources.limits.memory=1024Mi \
  \
  --set registry.server.resources.requests.cpu=100m \
  --set registry.server.resources.requests.memory=128Mi \
  --set registry.server.resources.limits.cpu=256m \
  --set registry.server.resources.limits.memory=1024Mi \
  \
  --set registry.controller.resources.requests.cpu=100m \
  --set registry.controller.resources.requests.memory=128Mi \
  --set registry.controller.resources.limits.cpu=256m \
  --set registry.controller.resources.limits.memory=1024Mi \
  \
  --set trivy.resources.requests.cpu=100m \
  --set trivy.resources.requests.memory=128Mi \
  --set trivy.resources.limits.cpu=256m \
  --set trivy.resources.limits.memory=1024Mi \
  \
  --set exporter.resources.requests.cpu=100m \
  --set exporter.resources.requests.memory=128Mi \
  --set exporter.resources.limits.cpu=256m \
  --set exporter.resources.limits.memory=1024Mi \
  \
  --set postgresql.primary.resources.requests.cpu=100m \
  --set postgresql.primary.resources.requests.memory=128Mi \
  --set postgresql.primary.resources.limits.cpu=256m \
  --set postgresql.primary.resources.limits.memory=1024Mi \
  \
  --set redis.master.resources.requests.cpu=100m \
  --set redis.master.resources.requests.memory=128Mi \
  --set redis.master.resources.limits.cpu=256m \
  --set redis.master.resources.limits.memory=1024Mi