$ErrorActionPreference = "Stop"

$registryUser = Read-Host "GitLab deploy token username"
$registryToken = [System.Net.NetworkCredential]::new("", (Read-Host "GitLab deploy token" -AsSecureString)).Password
if (-not $registryUser -or -not $registryToken) { throw "Both registry credentials are required." }
$auth = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${registryUser}:$registryToken"))
$config = @{ auths = @{ "registry.gitlab.com" = @{ auth = $auth } } } | ConvertTo-Json -Depth 5 -Compress
$encodedConfig = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($config))

$items = @(@{ apiVersion = "v1"; kind = "Namespace"; metadata = @{ name = "task5" } })
foreach ($namespace in @("flux-system", "task5")) {
    $items += @{
        apiVersion = "v1"
        kind = "Secret"
        metadata = @{ name = "gitlab-registry"; namespace = $namespace }
        type = "kubernetes.io/dockerconfigjson"
        data = @{ ".dockerconfigjson" = $encodedConfig }
    }
}

@{ apiVersion = "v1"; kind = "List"; items = $items } | ConvertTo-Json -Depth 10 |
    kubectl --context devops-task4 apply -f "-"
exit $LASTEXITCODE