#!/usr/bin/env bash

set -e
set -o pipefail

# --- 加载环境变量 ---
if [ -f .env ]; then
    # shellcheck disable=SC1091
    source .env
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# --- 检查 values.yml 文件是否存在 ---
if [ ! -f values.yml ]; then
    echo "错误: values.yml 文件不存在!"
    exit 1
fi

# --- 添加仓库并更新 ---
helm repo add bitnami https://charts.bitnami.com/bitnami --force-update

# --- 安装 / 升级 ---
helm upgrade --install ${RELEASE_NAME} bitnami/mongodb \
  --version ${CHART_VERSION} --namespace ${NAMESPACE} --create-namespace \
  -f values.yml

echo "Helm Chart '${RELEASE_NAME}' 已成功部署到命名空间 '${NAMESPACE}' 中。"
