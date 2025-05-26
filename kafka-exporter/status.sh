#!/usr/bin/env bash

NAMESPACE="kafka"
RELEASE_NAME="my-kafka-exporter"

kubectl get all -n ${RELEASE_NAME}
kubectl get pvc -n ${RELEASE_NAME}
