#!/usr/bin/env bash

helm repo add flink-operator-repo https://downloads.apache.org/flink/flink-kubernetes-operator-1.12.0/
helm repo update
helm install flink-kubernetes-operator flink-operator-repo/flink-kubernetes-operator -n flink --create-namespace
