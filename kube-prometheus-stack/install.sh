#!/usr/bin/env bash

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# --- 配置变量 ---
# Helm 安装相关
RELEASE_NAME="kube-prom-stack"
CHART_VERSION="72.6.2" # 请确认这是您希望使用的稳定版本，或注释掉以使用最新版
NAMESPACE="monitoring"

# 存储类和Ingress类
STORAGE_CLASS_NAME="nfs-storage"
INGRESS_CLASS_NAME="nginx" # 确保您的集群中已安装并配置了Nginx Ingress Controller

# Ingress 主机名 (请根据您的环境修改这些占位符)
# 确保这些域名可以解析到您的 Ingress Controller 的外部 IP
ALERTMANAGER_HOST="alertmanager.lbs.com"
PROMETHEUS_HOST="prometheus.lbs.com"
GRAFANA_HOST="grafana.lbs.com"

# 持久化存储大小
ALERTMANAGER_STORAGE_SIZE="8Gi"
PROMETHEUS_STORAGE_SIZE="32Gi" # Prometheus 需要的存储通常比 Alertmanager 和 Grafana 多
GRAFANA_STORAGE_SIZE="8Gi"

# Grafana 管理员密码 (生产环境建议修改或使用 Secret)
GRAFANA_ADMIN_PASSWORD="YOUR_PASSWORD" # 这是 chart 的默认密码

# --- 安装 kube-prometheus-stack ---
helm install ${RELEASE_NAME} prometheus-community/kube-prometheus-stack \
  --version ${CHART_VERSION} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  \
  --set alertmanager.enabled=true \
  --set alertmanager.ingress.enabled=true \
  --set alertmanager.ingress.ingressClassName=${INGRESS_CLASS_NAME} \
  --set alertmanager.ingress.hosts[0]=${ALERTMANAGER_HOST} \
  --set alertmanager.ingress.paths[0]="/" \
  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName=${STORAGE_CLASS_NAME} \
  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.accessModes[0]="ReadWriteOnce" \
  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage=${ALERTMANAGER_STORAGE_SIZE} \
  \
  --set prometheus.enabled=true \
  --set prometheus.ingress.enabled=true \
  --set prometheus.ingress.ingressClassName=${INGRESS_CLASS_NAME} \
  --set prometheus.ingress.hosts[0]=${PROMETHEUS_HOST} \
  --set prometheus.ingress.paths[0]="/" \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName=${STORAGE_CLASS_NAME} \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0]="ReadWriteOnce" \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=${PROMETHEUS_STORAGE_SIZE} \
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
  --set grafana.persistence.size=${GRAFANA_STORAGE_SIZE} \
  \
  --set prometheusOperator.enabled=true

echo ""
echo "kube-prometheus-stack (${RELEASE_NAME}) 安装过程已启动到命名空间 '${NAMESPACE}'。"
echo "---------------------------------------------------------------------"
echo "监控 Pod 状态: kubectl get pods -n ${NAMESPACE} -w"
echo ""
echo "访问服务 (请确保您的 DNS 配置正确或使用 Ingress Controller 的外部 IP):"
echo "  Alertmanager: http://${ALERTMANAGER_HOST}"
echo "  Prometheus:   http://${PROMETHEUS_HOST}"
echo "  Grafana:      http://${GRAFANA_HOST}"
echo "                (默认用户: admin, 默认密码: ${GRAFANA_ADMIN_PASSWORD})"
echo "---------------------------------------------------------------------"
echo "如果遇到问题, 使用 'helm status ${RELEASE_NAME} -n ${NAMESPACE}' 和 'kubectl logs -n ${NAMESPACE} -l app.kubernetes.io/name=prometheus-operator -c prometheus-operator' 进行排查。"
