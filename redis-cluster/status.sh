#!/usr/bin/env bash

NAMESPACE="redis-cluster"

kubectl get all -n ${NAMESPACE}
kubectl get pvc -n ${NAMESPACE}
