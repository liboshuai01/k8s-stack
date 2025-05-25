#!/usr/bin/env bash

HELM_RELEASE_NAME="redis-cluster"
NAMESPACE="redis-cluster"

helm uninstall "$HELM_RELEASE_NAME" -n "$NAMESPACE"

echo "Redis 集群卸载过程已启动。"
echo "如果 reclaimPolicy 不是 Delete，Persistent Volume Claims (PVCs) 可能需要手动删除。"
echo "请使用以下命令检查：kubectl get pvc -n ${NAMESPACE}"
