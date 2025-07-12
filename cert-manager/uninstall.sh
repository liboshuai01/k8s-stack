#!/usr/bin/env bash

set -e
set -o pipefail

kubectl delete -f cert-manager.yaml
