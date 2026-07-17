variable "extension_type" {
  type        = string
  description = <<DESCRIPTION
Type of the Extension, of which this resource is an instance of.  It must be one of the Extension Types registered with Microsoft.KubernetesConfiguration by the Extension publisher.
DESCRIPTION
}

variable "name" {
  type        = string
  description = <<DESCRIPTION
The name of the resource.
DESCRIPTION

  validation {
    condition     = length(var.name) >= 1
    error_message = "name must have a minimum length of 1."
  }
}

variable "parent_id" {
  type        = string
  description = <<DESCRIPTION
The parent resource ID for this resource. For an AKS cluster extension, this should be the resource ID of the AKS cluster to which this extension will be attached, in the format:
 - `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{clusterName}`
DESCRIPTION

  validation {
    error_message = "Must be an AKS cluster resource ID in the format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ContainerService/managedClusters/{clusterName}"
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.ContainerService/managedClusters/[^/]+$", var.parent_id))
  }
}

variable "additional_details" {
  type = object({
    docs                  = optional(string)
    release_notes         = optional(string)
    troubleshooting_guide = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Additional details provided by the extension publisher.

- `docs` - Documentation for the extension.
- `release_notes` - Release notes for the extension.
- `troubleshooting_guide` - Troubleshooting guide for the extension.
DESCRIPTION
}

variable "aks_assigned_identity" {
  type = object({
    client_id   = optional(string)
    object_id   = optional(string)
    resource_id = optional(string)
    type        = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Identity of the Extension resource in an AKS cluster

- `type` - The identity type.
- `client_id` - The client ID of the resource identity.
- `object_id` - The object ID of the resource identity.
- `resource_id` - The resource ID of the resource identity.

DESCRIPTION

  validation {
    condition     = var.aks_assigned_identity == null || var.aks_assigned_identity.type == null || contains(["SystemAssigned", "UserAssigned", "Workload"], var.aks_assigned_identity.type)
    error_message = "aks_assigned_identity.type must be one of: [\"SystemAssigned\", \"UserAssigned\", \"Workload\"]."
  }
}

variable "auto_upgrade_minor_version" {
  type        = bool
  default     = null
  description = <<DESCRIPTION
Flag to note if this extension participates in auto upgrade of minor version, or not.
DESCRIPTION
}

variable "auto_upgrade_mode" {
  type        = string
  default     = null
  description = "The extension auto-upgrade mode. Azure defaults this to `compatible`."

  validation {
    condition     = var.auto_upgrade_mode == null || contains(["none", "patch", "compatible"], var.auto_upgrade_mode)
    error_message = "auto_upgrade_mode must be one of: \"none\", \"patch\", or \"compatible\"."
  }
}

variable "configuration_protected_settings" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
Configuration settings that are sensitive, as name-value pairs for configuring this extension.
DESCRIPTION
  ephemeral   = true
}

variable "configuration_protected_settings_version" {
  type        = string
  default     = null
  description = <<DESCRIPTION
The version of the configuration protected settings. This is used to determine whether the protected settings have changed or not, since the values themselves are not tracked due to being sensitive. If this version value changes, then the protected settings will be applied again.
DESCRIPTION
}

variable "configuration_settings" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
Configuration settings, as name-value pairs for configuring this extension.
DESCRIPTION
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "extension_version" {
  type        = string
  default     = null
  description = <<DESCRIPTION
User-specified version of the extension for this extension to 'pin'. To use 'version', autoUpgradeMinorVersion must be 'false'.
DESCRIPTION
}

variable "managed_by" {
  type        = string
  default     = null
  description = "The fully qualified resource ID of the resource that manages this extension."
}

# tflint-ignore: terraform_unused_declarations
variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
Controls the Managed Identity configuration on this resource.

Only system-assigned identity is supported by the Microsoft.KubernetesConfiguration extension resource.
DESCRIPTION
  nullable    = false

  validation {
    condition     = length(var.managed_identities.user_assigned_resource_ids) == 0
    error_message = "managed_identities.user_assigned_resource_ids must be empty because this resource only supports system-assigned identity."
  }
}

variable "management_details" {
  type = object({
    access_details = optional(list(object({
      allowed_actions = optional(list(string))
      description     = optional(string)
      entity          = optional(string)
    })))
    category = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Management details for the extension.

- `access_details` - Access details for the managing entity.
  - `allowed_actions` - Actions allowed for the entity.
  - `description` - Description of the entity.
  - `entity` - Entity to which the access details apply.
- `category` - Category of the managing entity.
DESCRIPTION
}

variable "plan" {
  type = object({
    name           = string
    product        = string
    promotion_code = optional(string)
    publisher      = string
    version        = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Details of the resource plan.

- `name` - A user defined name of the 3rd Party Artifact that is being procured.
- `product` - The 3rd Party artifact that is being procured. E.g. NewRelic. Product maps to the OfferID specified for the artifact at the time of Data Market onboarding.
- `promotion_code` - A publisher provided promotion code as provisioned in Data Market for the said product/artifact.
- `publisher` - The publisher of the 3rd Party Artifact that is being bought. E.g. NewRelic
- `version` - The version of the desired product/artifact.

DESCRIPTION
}

variable "release_train" {
  type        = string
  default     = null
  description = <<DESCRIPTION
ReleaseTrain this extension participates in for auto-upgrade (e.g. Stable, Preview, etc.) - only if autoUpgradeMinorVersion is 'true'.
DESCRIPTION
}

variable "scope" {
  type = object({
    cluster = optional(object({
      release_namespace = optional(string)
    }))
    namespace = optional(object({
      target_namespace = optional(string)
    }))
  })
  default     = null
  description = <<DESCRIPTION
Scope at which the extension is installed.

- `cluster` - Specifies that the scope of the extension is Cluster
  - `release_namespace` - Namespace where the extension Release must be placed, for a Cluster scoped extension.  If this namespace does not exist, it will be created
- `namespace` - Specifies that the scope of the extension is Namespace
  - `target_namespace` - Namespace where the extension will be created for an Namespace scoped extension.  If this namespace does not exist, it will be created

DESCRIPTION

  validation {
    condition     = var.scope == null || (var.scope.cluster == null) != (var.scope.namespace == null)
    error_message = "scope must define exactly one of cluster or namespace."
  }
}

variable "statuses" {
  type = list(object({
    code           = optional(string)
    display_status = optional(string)
    level          = optional(string)
    message        = optional(string)
    time           = optional(string)
  }))
  default     = null
  description = <<DESCRIPTION
Statuses supplied by the extension publisher.

- `code` - Status code.
- `display_status` - Short status description.
- `level` - Status level.
- `message` - Detailed status message.
- `time` - ISO 8601 status timestamp.
DESCRIPTION

  validation {
    condition = var.statuses == null || alltrue([
      for status in var.statuses : status.level == null || contains(["Error", "Information", "Warning"], status.level)
    ])
    error_message = "Each statuses entry level must be one of: \"Error\", \"Information\", or \"Warning\"."
  }
}
