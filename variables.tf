variable "location" {
  type        = string
  description = <<DESCRIPTION
The location of the resource.
DESCRIPTION
}

variable "name" {
  type        = string
  description = <<DESCRIPTION
The name of the resource.
DESCRIPTION
}

variable "parent_id" {
  type        = string
  description = <<DESCRIPTION
The parent resource ID for this resource.
DESCRIPTION
}

variable "aks_assigned_identity" {
  type = object({
    type = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Identity of the Extension resource in an AKS cluster

- `type` - The identity type.

DESCRIPTION

  validation {
    condition     = var.aks_assigned_identity == null || var.aks_assigned_identity.type == null || contains(["SystemAssigned", "UserAssigned"], var.aks_assigned_identity.type)
    error_message = "aks_assigned_identity.type must be one of: [\"SystemAssigned\", \"UserAssigned\"]."
  }
}

variable "auto_upgrade_minor_version" {
  type        = bool
  default     = null
  description = <<DESCRIPTION
Flag to note if this extension participates in auto upgrade of minor version, or not.
DESCRIPTION
}

variable "configuraiton_protected_settings_version" {
  type        = string
  default     = null
  description = <<DESCRIPTION
The version of the configuration protected settings. This is used to determine whether the protected settings have changed or not, since the values themselves are not tracked due to being sensitive. If this version value changes, then the protected settings will be applied again.
DESCRIPTION
}

variable "configuration_protected_settings" {
  type        = map(string)
  ephemeral   = true
  default     = null
  description = <<DESCRIPTION
Configuration settings that are sensitive, as name-value pairs for configuring this extension.
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

variable "extension_type" {
  type        = string
  default     = null
  description = <<DESCRIPTION
Type of the Extension, of which this resource is an instance of.  It must be one of the Extension Types registered with Microsoft.KubernetesConfiguration by the Extension publisher.
DESCRIPTION
}

variable "extension_version" {
  type        = string
  default     = null
  description = <<DESCRIPTION
User-specified version of the extension for this extension to 'pin'. To use 'version', autoUpgradeMinorVersion must be 'false'.
DESCRIPTION
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
DESCRIPTION
  nullable    = false
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
}
