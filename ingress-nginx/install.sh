#!/usr/bin/env bash

set -x

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --set controller.hostNetwork=true \
  --set controller.dnsPolicy=ClusterFirstWithHostNet \
  --set-string controller.nodeSelector.ingress=true \
  --set controller.kind=DaemonSet \
  --set controller.service.enabled=true \
  --set controller.service.type=NodePort \
  --namespace ingress-nginx \
  --create-namespace

kubectl label node master ingress="true"
kubectl label node node1 ingress="true"
kubectl label node node2 ingress="true"