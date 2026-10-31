docker run --rm `
    -v /var/run/docker.sock:/var/run/docker.sock `
    -v "${PSScriptRoot}:/reports" `
    -v devops-task4-trivy-cache:/root/.cache/trivy `
    aquasec/trivy:0.76.1 image `
    --image-src docker `
    --scanners vuln `
    --format table `
    --output /reports/image-report.txt `
    --exit-code 1 `
    devops-task4:staging

$ScanResult = $LASTEXITCODE

Write-Host "Scan exit code: $ScanResult"

exit $ScanResult