#!/usr/bin/env bash

helm uninstall kafka-cluster -n kafka-cluster

echo "Kafka 集群卸载过程已启动。"
echo "如果 reclaimPolicy 不是 Delete，Persistent Volume Claims (PVCs) 可能需要手动删除。"
echo "请使用以下命令检查：kubectl get pvc -n kafka-cluster"
