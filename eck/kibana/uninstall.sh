#!/usr/bin/env bash

set -e
set -o pipefail

# --- 检查 values.yml 文件是否存在 ---
if [ ! -f values.yml ]; then
    echo "错误: values.yml 文件不存在!"
    exit 1
fi

# --- 卸载 ---
kubectl delete -f values.yml

echo "ElasticSearch 实例 已成功卸载"
