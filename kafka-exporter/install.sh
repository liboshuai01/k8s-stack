#!/usr/bin/env bash

# 添加库并更新
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# --- 配置变量 ---
RELEASE_NAME="my-kafka-exporter"
NAMESPACE="kafka"
CHART_VERSION="2.12.1"

# --- 安装命令 ---
helm install ${RELEASE_NAME} prometheus-community/prometheus-kafka-exporter --version ${CHART_VERSION} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  \
  --set kafkaServer[0]="my-kafka-cluster:9092" \
  --set prometheus.serviceMonitor.enabled=true \
  --set prometheus.serviceMonitor.namespace=monitoring \
  --set prometheus.serviceMonitor.additionalLabels.release=kube-prom-stack \
  \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=1000m \
  --set resources.limits.memory=2048Mi \

echo ""
echo "${RELEASE_NAME} 安装/升级过程已启动到命名空间 '${NAMESPACE}'。"
echo "---------------------------------------------------------------------"
echo "监控 Pod 状态: kubectl get pods -n ${NAMESPACE} -w"
echo "---------------------------------------------------------------------"
