#!/usr/bin/env bash

set -x

helm uninstall nfs-subdir-external-provisioner -n kube-system
