#!/usr/bin/env bash

set -e
set -o pipefail

# 获取 StorageClass 列表
kubectl get storageclass
