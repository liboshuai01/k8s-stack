#!/usr/bin/env bash

set -e
set -o pipefail

kubectl get all,pvc -n eck
