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

# --- 添加仓库并更新 ---
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# --- 安装 / 升级 ---
helm upgrade --install ${RELEASE_NAME} bitnami/jenkins \
  --version ${CHART_VERSION} --namespace ${NAMESPACE} --create-namespace \
  \
  --set global.defaultStorageClass=${STORAGE_CLASS_NAME} \
  --set replicaCount=${REPLICA_COUNT} \
  \
  --set jenkinsPassword=${JENKINS_ADMIN_PASSWORD} \
  \
  --set service.type=ClusterIP \
  \
  --set ingress.enabled=true \
  --set ingress.ingressClassName=${INGRESS_CLASS_NAME} \
  --set ingress.hostname=${JENKINS_HOST} \
  \
  --set persistence.size=16Gi \
  \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=1000m \
  --set resources.limits.memory=4096Mi \
  \
  --set tls.resources.requests.cpu=100m \
  --set tls.resources.requests.memory=128Mi \
  --set tls.resources.limits.cpu=256m \
  --set tls.resources.limits.memory=1024Mi \
  \
  --set extraEnvVars[0].name=TZ \
  --set extraEnvVars[0].value=Asia/Shanghai
