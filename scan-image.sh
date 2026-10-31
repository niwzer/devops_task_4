#!/bin/sh
set -e

docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "${PWD}/.cache/trivy:/root/.cache/trivy" \
    aquasec/trivy:0.76.1 image \
    --image-src docker --scanners vuln --format table \
    --exit-code 1 --timeout 10m \
    "${1:?Image name is required}" > image-report.txt