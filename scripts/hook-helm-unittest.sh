#!/usr/bin/env sh

set -eu

if helm plugin list | grep -q unittest; then
  helm unittest charts/*
else
  docker run --rm -v "$(pwd)":/apps helmunittest/helm-unittest charts/*
fi
