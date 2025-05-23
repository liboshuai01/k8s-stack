#!/usr/bin/env bash

set -x

kubectl get all -n kafka-cluster
kubectl get pvc -n kafka-cluster