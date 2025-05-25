#!/usr/bin/env bash

NAMESPACE="redis"
RELEASE_NAME="my-redis-cluster"

helm uninstall ${RELEASE_NAME} -n ${NAMESPACE}

echo "${RELEASE_NAME} 卸载过程已启动。"
echo "如果 reclaimPolicy 不是 Delete，Persistent Volume Claims (PVCs) 可能需要手动删除。"
echo "请使用以下命令检查：kubectl get pvc -n ${NAMESPACE}"
