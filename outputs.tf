output "aks_assigned_identity_principal_id" {
  description = "The principal ID of resource identity."
  value       = try(azapi_resource.this.output.properties.aksAssignedIdentity.principalId, null)
}

output "aks_assigned_identity_tenant_id" {
  description = "The tenant ID of resource."
  value       = try(azapi_resource.this.output.properties.aksAssignedIdentity.tenantId, null)
}

output "api_version" {
  description = "The resource api version"
  value       = try(azapi_resource.this.output.apiVersion, null)
}

output "current_version" {
  description = "Currently installed version of the extension."
  value       = try(azapi_resource.this.output.properties.currentVersion, null)
}

output "custom_location_settings" {
  description = "Custom Location settings properties."
  value       = try(azapi_resource.this.output.properties.customLocationSettings, {})
}

output "identity_principal_id" {
  description = "The principal ID of resource identity."
  value       = try(azapi_resource.this.output.identity.principalId, null)
}

output "identity_tenant_id" {
  description = "The tenant ID of resource."
  value       = try(azapi_resource.this.output.identity.tenantId, null)
}

output "name" {
  description = "The name of the created resource."
  value       = azapi_resource.this.name
}

output "package_uri" {
  description = "Uri of the Helm package"
  value       = try(azapi_resource.this.output.properties.packageUri, null)
}

output "resource_id" {
  description = "The ID of the created resource."
  value       = azapi_resource.this.id
}
