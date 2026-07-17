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

output "error_info" {
  description = "Error information reported by the extension."
  value       = try(azapi_resource.this.output.properties.errorInfo, null)
}

output "extension_state" {
  description = "State of the extension on the cluster."
  value       = try(azapi_resource.this.output.properties.extensionState, null)
}

output "identity_principal_id" {
  description = "The principal ID of resource identity."
  value       = try(azapi_resource.this.identity[0].principal_id, null)
}

output "identity_tenant_id" {
  description = "The tenant ID of resource."
  value       = try(azapi_resource.this.identity[0].tenant_id, null)
}

output "is_system_extension" {
  description = "Whether the extension is a system extension."
  value       = try(azapi_resource.this.output.properties.isSystemExtension, null)
}

output "name" {
  description = "The name of the created resource."
  value       = azapi_resource.this.name
}

output "package_uri" {
  description = "Uri of the Helm package"
  value       = try(azapi_resource.this.output.properties.packageUri, null)
}

output "provisioning_state" {
  description = "The provisioning state of the extension."
  value       = try(azapi_resource.this.output.properties.provisioningState, null)
}

output "resource_id" {
  description = "The ID of the created resource."
  value       = azapi_resource.this.id
}

output "statuses" {
  description = "Statuses reported by the extension."
  value       = try(azapi_resource.this.output.properties.statuses, [])
}
