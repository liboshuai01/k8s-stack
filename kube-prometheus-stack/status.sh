#!/usr/bin/env bash

NAMESPACE="monitoring"
RELEASE_NAME="kube-prometheus-stack"

kubectl get all -n ${NAMESPACE} -l app.kubernetes.io/instance=${RELEASE_NAME}
kubectl get pvc -n ${NAMESPACE} -l app.kubernetes.io/instance=${RELEASE_NAME}
