#!/usr/bin/env bash

set -x

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install redis-cluster bitnami/redis-cluster \
  --set-string global.storageClass="nfs-storage" \
  --set-string global.redis.password="YOUR_PASSWORD" \
  --set metrics.enabled=true \
  --namespace redis-cluster \
  --create-namespace
