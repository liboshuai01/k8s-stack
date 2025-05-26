#!/usr/bin/env bash

# --- 添加仓库并更新 ---
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# --- 配置变量 ---
NAMESPACE="ingress-nginx"
RELEASE_NAME="ingress-nginx"
CHART_VERSION="4.12.2"

# --- 安装 / 升级 ---
helm upgrade --install ${RELEASE_NAME} ingress-nginx/ingress-nginx \
  --version ${CHART_VERSION} --namespace ${NAMESPACE} --create-namespace \
  \
  --set controller.hostNetwork=true \
  --set controller.dnsPolicy=ClusterFirstWithHostNet \
  --set-string controller.nodeSelector.ingress="true" \
  --set controller.kind=DaemonSet \
  --set controller.service.enabled=true \
  --set controller.service.type=NodePort
