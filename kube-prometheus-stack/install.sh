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
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# --- 安装 / 升级 ---
helm upgrade --install ${RELEASE_NAME} prometheus-community/kube-prometheus-stack \
  --version ${CHART_VERSION} --namespace ${NAMESPACE} --create-namespace \
  \
  --set alertmanager.enabled=true \
  --set alertmanager.ingress.enabled=true \
  --set alertmanager.ingress.ingressClassName=${INGRESS_CLASS_NAME} \
  --set alertmanager.ingress.hosts[0]=${ALERTMANAGER_HOST} \
  --set alertmanager.ingress.paths[0]="/" \
  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName=${STORAGE_CLASS_NAME} \
  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.accessModes[0]="ReadWriteOnce" \
  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage=8Gi \
  \
  --set prometheus.enabled=true \
  --set prometheus.ingress.enabled=true \
  --set prometheus.ingress.ingressClassName=${INGRESS_CLASS_NAME} \
  --set prometheus.ingress.hosts[0]=${PROMETHEUS_HOST} \
  --set prometheus.ingress.paths[0]="/" \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName=${STORAGE_CLASS_NAME} \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0]="ReadWriteOnce" \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=32Gi \
  \
  --set grafana.enabled=true \
  --set grafana.adminPassword=${GRAFANA_ADMIN_PASSWORD} \
  --set grafana.ingress.enabled=true \
  --set grafana.ingress.ingressClassName=${INGRESS_CLASS_NAME} \
  --set grafana.ingress.hosts[0]=${GRAFANA_HOST} \
  --set grafana.ingress.path="/" \
  --set grafana.persistence.enabled=true \
  --set grafana.persistence.storageClassName=${STORAGE_CLASS_NAME} \
  --set grafana.persistence.accessModes[0]="ReadWriteOnce" \
  --set grafana.persistence.size=8Gi \
  \
  --set prometheusOperator.enabled=true
