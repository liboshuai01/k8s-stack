#!/usr/bin/env bash

set -x

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install kafka-cluster bitnami/kafka --version 32.2.6 \
  --namespace kafka-cluster \
  --create-namespace \
  --set-string global.defaultStorageClass="nfs-storage" \
  --set listeners.client.protocol=PLAINTEXT \
  --set listeners.client.sslClientAuth=none \
  --set listeners.controller.protocol=PLAINTEXT \
  --set listeners.controller.sslClientAuth=none \
  --set listeners.interbroker.protocol=PLAINTEXT \
  --set listeners.interbroker.sslClientAuth=none \
  --set listeners.external.protocol=PLAINTEXT \
  --set listeners.external.sslClientAuth=none \
  --set-string controller.persistence.storageClass="nfs-storage" \
  --set controller.persistence.size=20Gi \
  --set-string controller.logPersistence.storageClass="nfs-storage" \
  --set controller.logPersistence.size=8Gi \
  --set metrics.jmx.enabled=true

