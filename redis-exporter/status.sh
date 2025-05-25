#!/usr/bin/env bash

NAMESPACE="redis"
RELEASE_NAME="my-redis-exporter"

kubectl get all -n ${NAMESPACE} -l app.kubernetes.io/instance=${RELEASE_NAME}
kubectl get pvc -n ${NAMESPACE} -l app.kubernetes.io/instance=${RELEASE_NAME}
