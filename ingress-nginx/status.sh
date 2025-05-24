#!/usr/bin/env bash

kubectl get all -n ingress-nginx # 获取 ingress-nginx 命名空间下的所有资源
echo "--- Ingress Controller Pods Details ---"
kubectl get pods -n ingress-nginx -o wide -l app.kubernetes.io/name=ingress-nginx,app.kubernetes.io/component=controller
echo "--- Ingress Classes ---"
kubectl get ingressclass
