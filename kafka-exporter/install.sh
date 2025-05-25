#!/usr/bin/env bash

# 添加库并更新
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# --- 配置变量 ---
# Kafka 安装相关
RELEASE_NAME="my-kafka-exporter"
NAMESPACE="kafka"
CHART_VERSION="2.12.1"
STORAGE_CLASS="nfs"

# --- 安装 Kafka 集群 ---
helm install ${RELEASE_NAME} prometheus-community/prometheus-kafka-exporter --version ${CHART_VERSION} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  \
  --set kafkaServer[0]="my-kafka-cluster:9092" \
  --set prometheus.serviceMonitor.enabled=true \
  --set prometheus.serviceMonitor.namespace=monitoring \
  --set 'prometheus.serviceMonitor.additionalLabels={release:kube-prom-stack}'

echo ""
echo "${RELEASE_NAME} 安装/升级过程已启动到命名空间 '${NAMESPACE}'。"
echo "---------------------------------------------------------------------"
echo "监控 Pod 状态: kubectl get pods -n ${NAMESPACE} -w"
echo "---------------------------------------------------------------------"
