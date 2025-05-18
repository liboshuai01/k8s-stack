#!/usr/bin/env bash

set -x

helm uninstall kafka-cluster -n kafka-cluster
