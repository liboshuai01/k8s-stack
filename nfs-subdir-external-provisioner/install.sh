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

# --- 检查 values.yaml 文件是否存在 ---
if [ ! -f values.yaml ]; then
    echo "错误: values.yaml 文件不存在!"
    exit 1
fi

# --- 添加仓库并更新 ---
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update

# --- 安装 / 升级 ---
# 使用 -f values.yaml 来加载所有配置参数
helm upgrade --install ${RELEASE_NAME} nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --version ${CHART_VERSION} --namespace ${NAMESPACE} --create-namespace \
  -f values.yaml

echo "Helm Chart '${RELEASE_NAME}' 已成功部署到命名空间 '${NAMESPACE}' 中。"
