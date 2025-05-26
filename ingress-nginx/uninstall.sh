#!/usr/bin/env bash

NAMESPACE="ingress-nginx"
RELEASE_NAME="ingress-nginx"

helm uninstall ${RELEASE_NAME} -n ${NAMESPACE}
