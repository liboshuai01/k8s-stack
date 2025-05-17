#!/usr/bin/env bash

set -x

helm uninstall redis-cluster -n redis-cluster
