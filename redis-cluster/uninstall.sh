#!/usr/bin/env bash

HELM_RELEASE_NAME="redis-cluster"
NAMESPACE="redis-cluster" # 与安装脚本中的 NAMESPACE 一致

helm uninstall "$HELM_RELEASE_NAME" -n "$NAMESPACE"

echo "Redis Cluster 已卸载。"
echo "注意：持久卷声明 (PVCs) 可能仍然存在。如果需要删除数据，请手动删除它们："
echo "kubectl get pvc -n $NAMESPACE -l app.kubernetes.io/instance=$HELM_RELEASE_NAME"
echo "kubectl delete pvc -n $NAMESPACE -l app.kubernetes.io/instance=$HELM_RELEASE_NAME"
