#!/usr/bin/env bash

NAMESPACE="redis"

kubectl get all -n ${NAMESPACE}
kubectl get pvc -n ${NAMESPACE}
