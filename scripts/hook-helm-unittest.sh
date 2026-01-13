#!/usr/bin/env sh

set -eu

# helm unittest charts/*
docker run --rm -v $(pwd):/apps helmunittest/helm-unittest charts/*
