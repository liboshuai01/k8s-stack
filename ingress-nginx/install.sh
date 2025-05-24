#!/usr/bin/env bash

# 1. 添加 Ingress-Nginx Helm 仓库并更新
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# 2. (可选) 卸载可能冲突的预置 Ingress Controller (如 K3s 中的 Traefik)
# 如果你的集群（例如 K3s）默认安装了其他 Ingress Controller 并占用了 80/443 端口，
# 需要先卸载它们，以避免端口冲突。
helm uninstall traefik -n kube-system
helm uninstall traefik-crd -n kube-system # Traefik CRDs 可能也需要单独卸载

# 3. 使用 Helm 安装 Ingress-Nginx
helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.12.2 \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.hostNetwork=true \
  --set controller.dnsPolicy=ClusterFirstWithHostNet \
  --set-string controller.nodeSelector.ingress="true" \
  --set controller.kind=DaemonSet \
  --set controller.service.enabled=true \
  --set controller.service.type=NodePort

# 4. 为指定节点打上标签，以便 Ingress Controller Pod 调度到这些节点
kubectl label node master ingress=true --overwrite # 如果 master 节点也作为 ingress 节点
kubectl label node node1 ingress=true --overwrite
kubectl label node node2 ingress=true --overwrite
# 请根据你的实际节点名称和规划调整以上命令
# --overwrite 选项允许覆盖已存在的同名标签值
