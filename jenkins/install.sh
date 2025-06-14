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

# --- 添加 Bitnami 仓库并更新 ---
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# --- 安装 / 升级 Jenkins ---
helm upgrade --install ${RELEASE_NAME} bitnami/jenkins \
  --version ${CHART_VERSION} --namespace ${NAMESPACE} --create-namespace \
  \
  --set global.defaultStorageClass=${STORAGE_CLASS_NAME} \
  \
  --set jenkinsPassword=${JENKINS_ADMIN_PASSWORD} \
  \
  --set service.type=ClusterIP \
  \
  --set ingress.enabled=true \
  --set ingress.ingressClassName=${INGRESS_CLASS_NAME} \
  --set ingress.hostname=${JENKINS_HOST} \
  \
  --set persistence.size=8Gi \
  \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=1000m \
  --set resources.limits.memory=4096Mi \
  \
  --set rbac.create=true \
  --set serviceAccount.create=true
