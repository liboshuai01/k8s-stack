#!/usr/bin/env bash

kubectl create -f https://github.com/jetstack/cert-manager/releases/download/v1.8.2/cert-manager.yaml
helm repo add flink-operator-repo https://downloads.apache.org/flink/flink-kubernetes-operator-1.12.0/
helm install flink-kubernetes-operator flink-operator-repo/flink-kubernetes-operator -n flink --create-namespace
