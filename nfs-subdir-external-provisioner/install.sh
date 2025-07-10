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
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update

# --- 安装 / 升级 ---
helm upgrade --install "${RELEASE_NAME}" nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --version "${CHART_VERSION}" --namespace "${NAMESPACE}" --create-namespace \
  "${HELM_SET_ARGS[@]}"
