#!/usr/bin/env bash

NAMESPACE="kube-prom-stack"

kubectl get all -n ${NAMESPACE}
kubectl get pvc -n ${NAMESPACE}
