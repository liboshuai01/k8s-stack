#!/usr/bin/env bash

# --- 配置变量 ---
NAMESPACE="ingress-nginx"

kubectl get all -n ${NAMESPACE}
kubectl get ingressclass
