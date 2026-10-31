$ErrorActionPreference = "Stop"

$env:CI_REGISTRY_PASSWORD | docker login "$env:CI_REGISTRY" --username "$env:CI_REGISTRY_USER" --password-stdin
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

minikube -p devops-task4 image load --remote "$env:APP_IMAGE"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

(Get-Content -Raw "$PSScriptRoot/staging.yaml").Replace("APP_IMAGE_PLACEHOLDER", $env:APP_IMAGE) |
    kubectl --context devops-task4 apply -f "-"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

kubectl --context devops-task4 -n staging rollout status deployment/ecommerce "--timeout=300s"
exit $LASTEXITCODE
