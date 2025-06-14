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
helm repo add stevehipwell https://stevehipwell.github.io/helm-charts/
helm repo update

# -- 创建  namespace --
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
EOF

# -- 创建 secret --
kubectl create secret generic "${RELEASE_NAME}-secret" \
  --from-literal=password="${NEXUS_ADMIN_PASSWORD}" \
  --namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

# --- 安装 / 升级 ---
helm upgrade --install "${RELEASE_NAME}" stevehipwell/nexus3 \
  --version "${CHART_VERSION}" --namespace "${NAMESPACE}" --create-namespace \
  \
  --set ingress.enabled=true \
  --set ingress.ingressClassName="${INGRESS_CLASS_NAME}" \
  --set "ingress.hosts[0]=${NEXUS_HOST}" \
  \
  --set replicas=${REPLICAS} \
  \
  --set persistence.enabled=true \
  --set persistence.storageClass="${STORAGE_CLASS_NAME}" \
  --set persistence.size=32Gi \
  --set persistence.retainDeleted=true \
  --set persistence.retainScaled=true \
  \
  --set install4jAddVmParams="-Xms2g -Xmx2g -XX:MaxDirectMemorySize=3g" \
  \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=1000m \
  --set resources.limits.memory=4096Mi \
  \
  --set tailLogs.resources.requests.cpu=100m \
  --set tailLogs.resources.requests.memory=128Mi \
  --set tailLogs.resources.limits.cpu=250m \
  --set tailLogs.resources.limits.memory=1024Mi \
  \
  --set rootPassword.secret="${RELEASE_NAME}-secret" \
  --set config.enabled=true \
  \
  --set metrics.enabled=true \
  --set metrics.serviceMonitor.enabled=true \
  --set metrics.serviceMonitor.namespace="${PROMETHEUS_NAMESPACE}" \
  --set metrics.serviceMonitor.labels.release="${PROMETHEUS_RELEASE_LABEL}" \
  \
  --set env[0].name=TZ \
  --set env[0].value=Asia/Shanghai
