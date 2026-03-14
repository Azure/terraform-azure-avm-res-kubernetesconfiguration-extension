output "resource_id" {
  description = "The ID of the created resource."
  value       = azapi_resource.this.id
}

output "name" {
  description = "The name of the created resource."
  value       = azapi_resource.this.name
}

output "api_version" {
  description = "The resource api version"
  value       = try(azapi_resource.this.output.apiVersion, null)
}

output "identity_principal_id" {
  description = "The principal ID of resource identity."
  value       = try(azapi_resource.this.output.identity.principalId, null)
}

output "identity_tenant_id" {
  description = "The tenant ID of resource."
  value       = try(azapi_resource.this.output.identity.tenantId, null)
}

output "aks_assigned_identity_principal_id" {
  description = "The principal ID of resource identity."
  value       = try(azapi_resource.this.output.properties.aksAssignedIdentity.principalId, null)
}

output "aks_assigned_identity_tenant_id" {
  description = "The tenant ID of resource."
  value       = try(azapi_resource.this.output.properties.aksAssignedIdentity.tenantId, null)
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
  description = "Error information from the Agent - e.g. errors during installation."
  value       = try(azapi_resource.this.output.properties.errorInfo, {})
}

output "error_info_additional_info" {
  description = "The error additional info."
  value       = try(azapi_resource.this.output.properties.errorInfo.additionalInfo, [])
}

output "error_info_code" {
  description = "The error code."
  value       = try(azapi_resource.this.output.properties.errorInfo.code, null)
}

output "error_info_details" {
  description = "The error details."
  value       = try(azapi_resource.this.output.properties.errorInfo.details, [])
}

output "error_info_message" {
  description = "The error message."
  value       = try(azapi_resource.this.output.properties.errorInfo.message, null)
}

output "error_info_target" {
  description = "The error target."
  value       = try(azapi_resource.this.output.properties.errorInfo.target, null)
}

output "is_system_extension" {
  description = "Flag to note if this extension is a system extension"
  value       = try(azapi_resource.this.output.properties.isSystemExtension, null)
}

output "package_uri" {
  description = "Uri of the Helm package"
  value       = try(azapi_resource.this.output.properties.packageUri, null)
}

output "system_data" {
  description = "Azure Resource Manager metadata containing createdBy and modifiedBy information."
  value       = try(azapi_resource.this.output.systemData, {})
}

output "type" {
  description = "The resource type"
  value       = try(azapi_resource.this.output.type, null)
}

