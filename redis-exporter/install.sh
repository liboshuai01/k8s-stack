#!/usr/bin/env bash

# 添加库并更新
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# --- 配置变量 ---
RELEASE_NAME="my-redis-exporter"  # Redis Exporter 的发布名称
NAMESPACE="redis"            # Redis Exporter 将被安装到的命名空间
CHART_VERSION="6.10.3"            # 根据需要调整到最新或兼容版本，可通过 'helm search repo prometheus-community/redis-exporter' 查看

# Redis Cluster 的服务地址，根据 'kubectl get service -n redis' 的输出
# 格式为 redis://<service-name>.<namespace>:<port>
REDIS_CLUSTER_ADDRESS="redis://my-redis-cluster-0.my-redis-cluster-headless.redis.svc.cluster.local:6379"

# --- 安装/升级命令 ---
helm upgrade --install ${RELEASE_NAME} prometheus-community/prometheus-redis-exporter --version ${CHART_VERSION} \
  --namespace ${NAMESPACE} \
  --create-namespace \
  \
  --set redisAddress="${REDIS_CLUSTER_ADDRESS}" \
  \
  --set serviceMonitor.enabled=true \
  --set serviceMonitor.namespace=monitoring \
  --set serviceMonitor.labels.release="kube-prom-stack" \
  \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=128Mi \
  --set resources.limits.cpu=1000m \
  --set resources.limits.memory=2048Mi \
  \
  --set auth.enabled=true \
  --set auth.redisPassword="YOUR_PASSWORD" \
  # --set auth.secret.name="my-redis-cluster" \
  # --set auth.secret.key="redis-password-key-in-secret" \

  # 如果需要更详细的日志，可以设置extraArgs
  # --set extraArgs.log-level="debug" \

echo ""
echo "${RELEASE_NAME} 安装/升级过程已启动到命名空间 '${NAMESPACE}'。"
echo "---------------------------------------------------------------------"
echo "监控 Pod 状态: kubectl get pods -n ${NAMESPACE} -l app.kubernetes.io/name=redis-exporter -w"
echo "验证 ServiceMonitor: kubectl get servicemonitor -n ${NAMESPACE} ${RELEASE_NAME}"
echo "---------------------------------------------------------------------"