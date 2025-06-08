#!/usr/bin/env bash

set -e

# --- 加载变量 ---
if [ -f .env ]; then
    source .env
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# --- 执行查询命令 ---
kubectl get all -n ${NAMESPACE}
kubectl get ingressclass
