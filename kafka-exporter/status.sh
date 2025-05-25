#!/usr/bin/env bash

NAMESPACE="kafka"

kubectl get all -n ${NAMESPACE}
kubectl get pvc -n ${NAMESPACE}
