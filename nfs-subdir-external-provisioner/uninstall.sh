#!/usr/bin/env bash

# 使用 Helm 卸载 nfs-subdir-external-provisioner
# 假设 release 名称为 nfs-subdir-external-provisioner (与 install.sh 中使用的名称一致)
# 且位于 kube-system 命名空间
helm uninstall nfs-subdir-external-provisioner -n kube-system

echo "NFS Subdir External Provisioner uninstallation initiated."
echo "You may also want to remove the Helm repository if no longer needed:"
echo "helm repo remove nfs-subdir-external-provisioner"
# 并且手动清理 StorageClass (如果helm uninstall 未自动删除)
# kubectl delete storageclass nfs
