#!/usr/bin/env bash

NAMESPACE="redis-cluster" # 与安装脚本中的 NAMESPACE 一致

echo "--- Helm Release 状态 ---"
helm list -n "$NAMESPACE"

echo ""
echo "--- Pods 状态 (等待所有 Pods Running 且 Ready) ---"
kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/name=redis-cluster -w

# 如果想查看所有资源，可以使用:
# kubectl get all -n "$NAMESPACE"
