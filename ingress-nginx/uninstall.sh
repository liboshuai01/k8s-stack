#!/usr/bin/env bash

# --- 加载变量 ---
if [ -f .env ]; then
    export $(grep -v '^#' .env | sed 's/\r$//' | xargs)
else
    echo "错误: .env 文件不存在!"
    exit 1
fi

# --- 执行卸载命令 ---
helm uninstall ${RELEASE_NAME} -n ${NAMESPACE}
