#!/usr/bin/env bash

# 获取 StorageClass 列表并筛选出 nfs-storage
kubectl get storageclass | grep nfs-storage
