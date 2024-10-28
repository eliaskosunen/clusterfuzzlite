#!/usr/bin/env bash

set -eux

# $1 contains path to google/oss-fuzz
OSS_FUZZ_DIR="$(realpath "$1")"
OSS_FUZZ_INFRA_DIR="$OSS_FUZZ_DIR/infra"
OSS_FUZZ_CIFUZZ_DIR="$OSS_FUZZ_INFRA_DIR/cifuzz"

# $2 and $3 contain image tags
BUILD_FUZZERS_TAG=$2
RUN_FUZZERS_TAG=$3

docker build \
    --tag gcr.io/oss-fuzz-base/cifuzz-base \
    --file "$OSS_FUZZ_CIFUZZ_DIR/cifuzz-base/Dockerfile" \
    "$OSS_FUZZ_DIR"

docker build \
    --tag $BUILD_FUZZERS_TAG-test:latest \
    --tag $BUILD_FUZZERS_TAG:latest \
    --file "$OSS_FUZZ_INFRA_DIR/build_fuzzers.Dockerfile" \
    "$OSS_FUZZ_INFRA_DIR"

docker build \
    --tag $RUN_FUZZERS_TAG-test:latest \
    --tag $RUN_FUZZERS_TAG:latest \
    --file "$OSS_FUZZ_INFRA_DIR/run_fuzzers.Dockerfile" \
    "$OSS_FUZZ_INFRA_DIR"
