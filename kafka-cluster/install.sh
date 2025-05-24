#!/usr/bin/env bash

# 添加 Bitnami Helm 仓库并更新
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# --- 配置变量 ---
# Kafka 安装相关
KAFKA_RELEASE_NAME="kafka-cluster"
KAFKA_NAMESPACE="kafka-cluster"
KAFKA_CHART_VERSION="32.2.6" # 请确认这是您希望使用的稳定版本
STORAGE_CLASS="nfs-storage"

# Prometheus Stack 的 Release 名称 (必须与你安装 kube-prometheus-stack 时使用的 RELEASE_NAME 一致)
# 从你的 kube-prometheus-stack 脚本中，我们知道这个值是 "kube-prom-stack"
PROM_STACK_RELEASE_NAME="kube-prom-stack"
PROM_STACK_NAMESPACE="monitoring" # ServiceMonitor将创建在这个命名空间

# --- 安装 Kafka 集群 ---
helm install ${KAFKA_RELEASE_NAME} bitnami/kafka --version ${KAFKA_CHART_VERSION} \
  --namespace ${KAFKA_NAMESPACE} \
  --create-namespace \
  --set-string global.defaultStorageClass="${STORAGE_CLASS}" \
  --set listeners.client.protocol=PLAINTEXT \
  --set listeners.client.sslClientAuth=none \
  --set listeners.controller.protocol=PLAINTEXT \
  --set listeners.controller.sslClientAuth=none \
  --set listeners.interbroker.protocol=PLAINTEXT \
  --set listeners.interbroker.sslClientAuth=none \
  --set listeners.external.protocol=PLAINTEXT \
  --set listeners.external.sslClientAuth=none \
  --set controller.replicaCount=3 \
  --set controller.persistence.enabled=true \
  --set controller.persistence.size=16Gi \
  --set controller.logPersistence.enabled=true \
  --set controller.logPersistence.size=8Gi \
  \
  --set metrics.jmx.enabled=true \
  --set metrics.prometheusOperator.enabled=true \
  --set metrics.prometheusOperator.serviceMonitor.enabled=true \
  --set metrics.prometheusOperator.serviceMonitor.namespace=${PROM_STACK_NAMESPACE} \
  --set metrics.prometheusOperator.serviceMonitor.labels.release=${PROM_STACK_RELEASE_NAME}
  # 如果需要分离的 Broker 节点 (KRaft 提供的 Dedicated Broker Mode)，请取消注释并配置以下参数
  # --set broker.replicaCount=3 \
  # --set broker.persistence.enabled=true \
  # --set broker.persistence.size=16Gi \
  # --set broker.logPersistence.enabled=true \
  # --set broker.logPersistence.size=8Gi \

echo ""
echo "Kafka 集群 (${KAFKA_RELEASE_NAME}) 安装/升级过程已启动到命名空间 '${KAFKA_NAMESPACE}'。"
echo "ServiceMonitor 将创建在命名空间 '${PROM_STACK_NAMESPACE}' 中，并带有标签 'release: ${PROM_STACK_RELEASE_NAME}'。"
echo "---------------------------------------------------------------------"
echo "监控 Pod 状态: kubectl get pods -n ${KAFKA_NAMESPACE} -w"
echo "检查 ServiceMonitor: kubectl get servicemonitor -n ${PROM_STACK_NAMESPACE} ${KAFKA_RELEASE_NAME}-kafka"
echo "检查 Prometheus Targets: 访问 http://${PROMETHEUS_HOST}/targets (其中 PROMETHEUS_HOST 是你的Prometheus Ingress主机名)"
echo "---------------------------------------------------------------------"
echo "如果遇到问题, 请检查 Prometheus Operator 日志: kubectl logs -n ${PROM_STACK_NAMESPACE} -l app.kubernetes.io/name=prometheus-operator -c prometheus-operator"