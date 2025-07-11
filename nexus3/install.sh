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

# --- 检查 values.yml 文件是否存在 ---
if [ ! -f values.yml ]; then
    echo "错误: values.yml 文件不存在!"
    exit 1
fi

# --- 添加仓库并更新 ---
helm repo add stevehipwell https://stevehipwell.github.io/helm-charts/
helm repo update

# --- 创建命名空间 (如果不存在) ---
# 注意：helm upgrade --create-namespace 也能创建命名空间，但提前创建可以确保 secret 先于 helm release 被创建
kubectl get ns "${NAMESPACE}" >/dev/null 2>&1 || kubectl create namespace "${NAMESPACE}"

# --- 创建 Nexus admin 密码的 Secret ---
# 这个 Secret 必须在 Helm Chart 部署之前存在
PASSWORD_SECRET_NAME="${RELEASE_NAME}-secret"
NEXUS_ADMIN_PASSWORD=${NEXUS_ADMIN_PASSWORD}

# 检查 Secret 是否已存在，避免重复创建报错
if ! kubectl get secret "${PASSWORD_SECRET_NAME}" -n "${NAMESPACE}" >/dev/null 2>&1; then
    echo "创建 Secret '${PASSWORD_SECRET_NAME}' 到命名空间 '${NAMESPACE}'..."
    kubectl create secret generic "${PASSWORD_SECRET_NAME}" \
      --from-literal=password="${NEXUS_ADMIN_PASSWORD}" \
      --namespace "${NAMESPACE}" || { echo "错误: 创建 Secret 失败!"; exit 1; }
else
    echo "Secret '${PASSWORD_SECRET_NAME}' 已存在于命名空间 '${NAMESPACE}'，跳过创建。"
    # 如果你需要更新密码，请手动删除 Secret 后重新运行此脚本，或者使用 kubectl patch/edit secret
fi


# --- 安装 / 升级 ---
helm upgrade --install "${RELEASE_NAME}" stevehipwell/nexus3 \
  --version "${CHART_VERSION}" --namespace "${NAMESPACE}" --create-namespace \
  -f values.yml

echo "Helm Chart '${RELEASE_NAME}' 已成功部署到命名空间 '${NAMESPACE}' 中。"

