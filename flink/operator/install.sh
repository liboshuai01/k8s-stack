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

# --- 添加 Bitnami Helm 仓库并更新 ---
helm repo add flink-operator-repo https://downloads.apache.org/flink/flink-kubernetes-operator-${OPERATOR_VERSION}/
helm repo update

# --- 安装 / 升级 ---
helm upgrade --install ${RELEASE_NAME} flink-operator-repo/flink-kubernetes-operator \
  --namespace ${NAMESPACE} --create-namespace

echo "Helm Chart '${RELEASE_NAME}' 已成功部署到命名空间 '${NAMESPACE}' 中。"
