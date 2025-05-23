#!/usr/bin/env bash

set -x

helm uninstall kafka-cluster -n kafka-cluster

echo "Kafka cluster uninstallation initiated."
echo "Persistent Volume Claims (PVCs) might need to be manually deleted if reclaimPolicy is not Delete."
echo "Check with: kubectl get pvc -n kafka-cluster"