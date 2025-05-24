#!/usr/bin/env bash

# 添加 nfs-subdir-external-provisioner 的 Helm 仓库
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
# 更新本地 Helm 仓库列表
helm repo update

# 使用 Helm 安装 nfs-subdir-external-provisioner
# 注意：这里的 release 名称是 nfs-subdir-external-provisioner
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --version 4.0.18 \
  --namespace kube-system \
  --create-namespace \
  --set nfs.server=master \
  --set nfs.path=/data/nfs/k8s \
  --set storageClass.name=nfs-storage \
  --set storageClass.defaultClass=true \
  --set rbac.create=true

echo "NFS Subdir External Provisioner installation initiated."
echo "Run 'kubectl get pods -n kube-system -l app.kubernetes.io/name=nfs-subdir-external-provisioner' to check pod status."
echo "Run 'kubectl get storageclass' to check the StorageClass."