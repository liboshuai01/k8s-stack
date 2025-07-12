#!/usr/bin/env bash

set -e
set -o pipefail

# --- 安装 ---
kubectl create -f cert-manager.yaml

echo "'cert-manager' 已成功部署到命名空间 'cert-manager' 中。"
