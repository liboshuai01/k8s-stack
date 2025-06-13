#!/usr/bin/env bash

helm uninstall flink-kubernetes-operator -n flink
kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v1.8.2/cert-manager.yaml
