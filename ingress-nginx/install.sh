#!/usr/bin/env bash

set -e
set -o pipefail

# --- 加载变量 ---
if [ -f .env ]; then
    source .env
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# --- 添加仓库并更新 ---
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

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
