#!/usr/bin/env bash

set -e
set -o pipefail

# --- 加载环境变量 ---
if [ -f .env ]; then
    source .env
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# --- 添加仓库并更新 ---
helm repo add metallb https://metallb.github.io/metallb --force-update

# --- 安装 / 升级 ---
helm upgrade --install ${RELEASE_NAME} metallb/metallb \
  --version ${CHART_VERSION} --namespace ${NAMESPACE} --create-namespace

echo "Helm Chart '${RELEASE_NAME}' 已成功部署到命名空间 '${NAMESPACE}' 中。"
