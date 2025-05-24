#!/usr/bin/env bash

helm uninstall ingress-nginx -n ingress-nginx

# (可选) 移除之前添加的节点标签
# kubectl label node master ingress-
# kubectl label node node1 ingress-
# kubectl label node node2 ingress-
# 请根据你的实际节点名称调整
