set -e

trivy image --image-src docker --scanners vuln --format table \
    --output image-report.txt --exit-code 1 --timeout 10m "${1:?Image name is required}"