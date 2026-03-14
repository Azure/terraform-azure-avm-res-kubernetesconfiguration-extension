variable "name" {
  description = <<DESCRIPTION
The name of the resource.
DESCRIPTION
  type        = string
}

variable "parent_id" {
  description = <<DESCRIPTION
The parent resource ID for this resource.
DESCRIPTION
  type        = string
}

variable "location" {
  description = <<DESCRIPTION
The location of the resource.
DESCRIPTION
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "managed_identities" {
  description = <<DESCRIPTION
Controls the Managed Identity configuration on this resource.
DESCRIPTION
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default  = {}
  nullable = false
}

variable "plan" {
  description = <<DESCRIPTION
Details of the resource plan.

- `name` - A user defined name of the 3rd Party Artifact that is being procured.
- `product` - The 3rd Party artifact that is being procured. E.g. NewRelic. Product maps to the OfferID specified for the artifact at the time of Data Market onboarding.
- `promotion_code` - A publisher provided promotion code as provisioned in Data Market for the said product/artifact.
- `publisher` - The publisher of the 3rd Party Artifact that is being bought. E.g. NewRelic
- `version` - The version of the desired product/artifact.

DESCRIPTION
  type = object({
    name           = string
    product        = string
    promotion_code = optional(string)
    publisher      = string
    version        = optional(string)
  })
  default = null
}

variable "aks_assigned_identity" {
  description = <<DESCRIPTION
Identity of the Extension resource in an AKS cluster

- `type` - The identity type.

DESCRIPTION
  type = object({
    type = optional(string)
  })
  default = null
  validation {
    condition     = var.aks_assigned_identity == null || var.aks_assigned_identity.type == null || contains(["SystemAssigned", "UserAssigned"], var.aks_assigned_identity.type)
    error_message = "aks_assigned_identity.type must be one of: [\"SystemAssigned\", \"UserAssigned\"]."
  }
}

variable "auto_upgrade_minor_version" {
  description = <<DESCRIPTION
Flag to note if this extension participates in auto upgrade of minor version, or not.
DESCRIPTION
  type        = bool
  default     = null
}

variable "configuration_protected_settings" {
  description = <<DESCRIPTION
Configuration settings that are sensitive, as name-value pairs for configuring this extension.
DESCRIPTION
  type        = map(string)
  default     = null
  ephemeral   = true
}

variable "configuraiton_protected_settings_version" {
  type        = string
  default     = null
  description = <<DESCRIPTION
The version of the configuration protected settings. This is used to determine whether the protected settings have changed or not, since the values themselves are not tracked due to being sensitive. If this version value changes, then the protected settings will be applied again.
DESCRIPTION
}

variable "configuration_settings" {
  description = <<DESCRIPTION
Configuration settings, as name-value pairs for configuring this extension.
DESCRIPTION
  type        = map(string)
  default     = null
}

variable "extension_type" {
  description = <<DESCRIPTION
Type of the Extension, of which this resource is an instance of.  It must be one of the Extension Types registered with Microsoft.KubernetesConfiguration by the Extension publisher.
DESCRIPTION
  type        = string
  default     = null
}

variable "release_train" {
  description = <<DESCRIPTION
ReleaseTrain this extension participates in for auto-upgrade (e.g. Stable, Preview, etc.) - only if autoUpgradeMinorVersion is 'true'.
DESCRIPTION
  type        = string
  default     = null
}

variable "scope" {
  description = <<DESCRIPTION
Scope at which the extension is installed.

- `cluster` - Specifies that the scope of the extension is Cluster
  - `release_namespace` - Namespace where the extension Release must be placed, for a Cluster scoped extension.  If this namespace does not exist, it will be created
- `namespace` - Specifies that the scope of the extension is Namespace
  - `target_namespace` - Namespace where the extension will be created for an Namespace scoped extension.  If this namespace does not exist, it will be created

DESCRIPTION
  type = object({
    cluster = optional(object({
      release_namespace = optional(string)
    }))
    namespace = optional(object({
      target_namespace = optional(string)
    }))
  })
  default = null
}

variable "extension_version" {
  description = <<DESCRIPTION
User-specified version of the extension for this extension to 'pin'. To use 'version', autoUpgradeMinorVersion must be 'false'.
DESCRIPTION
  type        = string
  default     = null
}


variable "enable_telemetry" {
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module. For more information see https://aka.ms/avm/telemetryinfo.
DESCRIPTION
  type        = bool
  default     = true
  nullable    = false
}

