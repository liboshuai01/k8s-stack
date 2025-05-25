#!/usr/bin/env bash

NAMESPACE="monitoring"

kubectl get all -n ${NAMESPACE}
kubectl get pvc -n ${NAMESPACE}
