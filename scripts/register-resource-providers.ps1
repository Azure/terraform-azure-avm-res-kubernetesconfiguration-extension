$ErrorActionPreference = "Stop"

$providers = @(
  "Microsoft.ContainerService"
  "Microsoft.KubernetesConfiguration"
)

foreach ($provider in $providers) {
  $state = az provider show --namespace $provider --query registrationState --output tsv
  if ($LASTEXITCODE -ne 0) {
    throw "Unable to query resource provider $provider."
  }

  if ($state -ne "Registered") {
    az provider register --namespace $provider --wait
    if ($LASTEXITCODE -ne 0) {
      throw "Unable to register resource provider $provider."
    }
  }
}
