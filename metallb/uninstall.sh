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

# --- 执行卸载命令 ---
kubectl delete -f config.yml
helm uninstall ${RELEASE_NAME} -n ${NAMESPACE}
