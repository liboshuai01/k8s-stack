#!/usr/bin/env bash

NAMESPACE="kafka"
RELEASE_NAME="my-kafka-cluster"

kubectl get all -n ${NAMESPACE} -l app.kubernetes.io/instance=${RELEASE_NAME}
kubectl get pvc -n ${NAMESPACE} -l app.kubernetes.io/instance=${RELEASE_NAME}
