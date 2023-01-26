variable "display_name" {
    type = string
    description = "(Required) The friendly name for this Conditional Access Policy."
}

variable "state" {
  type = string
  description = "(Required) Specifies the state of the policy object. Possible values are: enabled, disabled and enabledForReportingButNotEnforced"
  validation {
    condition = contains(["enabled", "disabled", "enabledForReportingButNotEnforced"])
    error_message = "The state value must be a string and one of the following possible vlaues: 'enabled', 'disabled', 'enabledForReportingButNotEnforced'"
  }
}

################
# Conditions
################

variable "client_app_types" {
    type = list(string)
    description = "(Required) A list of client application types included in the policy. Possible values are: all, browser, mobileAppsAndDesktopClients, exchangeActiveSync, easSupported and other."
    validation {
      condition = contains(["all", "browser", "mobileAppsAndDesktopClients", "exchangeActiveSync", "easSupported", "other"])
      error_message = "The client_app_types value must be a list of strings and one or more of the following possibile values: 'all', 'browser', 'mobileAppsAndDesktopClients', 'exchangeActiveSync', 'easSupported', 'other'"
    }
}

variable "sign_in_risk_levels" {
    type = list(string)
    description = "(Optional) A list of sign-in risk levels included in the policy. Possible values are: low, medium, high, hidden, none, unknownFutureValue."
    default = null
    validation {
      condition = contains(["low", "medium", "high", "hidden", "none", "unknownFutureValue"])
      error_message = "The sign_in_risk_levels value must be a list of strings and one or more of the following possible values: 'low', 'medium', 'high', 'hidden', 'none', 'unknownFutureValue'"
    }
}

variable "user_risk_levels" {
    type = list(string)
    description = "(Optional) A list of user risk levels included in the policy. Possible values are: low, medium, high, hidden, none, unknownFutureValue."
    validation {
      condition = contains(["low", "medium", "high", "hidden", "none", "unknownFutureValue"])
      error_message = "The user_risk_levels value must be a list of strings and one or more of the following possible values: 'low', 'medium', 'high', 'hidden', 'none', 'unknownFutureValue'"
    }
}

################
# Conditions - Applications
################

variable "excluded_applications" {
    type = list(string)
    description = "(Optional) A list of application IDs explicitly excluded from the policy. Can also be set to Office365."
    default = null
}

variable "included_applications" {
    type = list(string)
    description = "(Optional) A list of application IDs the policy applies to, unless explicitly excluded (in excluded_applications). Can also be set to All, None or Office365. Cannot be specified with included_user_actions. One of included_applications or included_user_actions must be specified."
    default = null
}

variable "included_user_actions" {
    type = list(string)
    description = "(Optional) A list of user actions to include. Supported values are urn:user:registerdevice and urn:user:registersecurityinfo. Cannot be specified with included_applications. One of included_applications or included_user_actions must be specified."
    default = null
}

################
# Conditions - Devices
################

variable "device_filter_mode" {
    type = string
    description = "(Optional) Whether to include in, or exclude from, matching devices from the policy. Supported values are include or exclude."
    default = null
    validation {
        condition = contains(["include", "exclude"])
        error_message = "The device_filter_mode value must be a string and one of the following possible values: 'include' or 'exclude'"
    }
}

variable "device_filter_rule" {
    type = string
    description = "(Required) Condition filter to match devices. For more information, see official documentation."
    default = null
}

################
# Conditions - Locations
################

variable "excluded_locations" {
    type = list(string)
    description = "(Optional) A list of location IDs excluded from scope of policy. Can also be set to AllTrusted."
    default = null
}

variable "included_locations" {
    type = list(string)
    description = "(Required) A list of location IDs in scope of policy unless explicitly excluded. Can also be set to All, or AllTrusted."
    default = null
}

################
# Conditions - Platforms
################

variable "excluded_platforms" {
    type = list(string)
    description = "(Optional) A list of platforms explicitly excluded from the policy. Possible values are: all, android, iOS, linux, macOS, windows, windowsPhone or unknownFutureValue."
    validation {
      condition = contains(["all", "android", "iOS", "linux", "macOS", "windows", "windowsPhone", "unknownFutureValue"])
      error_message = "The excluded_platforms value must be a list of strings and one or more from the following possible values: 'all', 'android', 'iOS', 'linux', 'macOS', 'windows', 'windowsPhone', 'unknownFutureValue'"
    }
}

variable "included_platforms" {
    type = list(string)
    description = "(Required) A list of platforms the policy applies to, unless explicitly excluded. Possible values are: all, android, iOS, linux, macOS, windows, windowsPhone or unknownFutureValue."
    validation {
      condition = contains(["all", "android", "iOS", "linux", "macOS", "windows", "windowsPhone", "unknownFutureValue"])
      error_message = "The included_platforms value must be a list of strings and one or more from the following possible values: 'all', 'android', 'iOS', 'linux', 'macOS', 'windows', 'windowsPhone', 'unknownFutureValue'"
    }
}

################
# Conditions - Users
################

variable "excluded_groups" {
    type = list(string)
    description = "(Optional) A list of group IDs excluded from scope of policy."
    default = null
}

variable "excluded_roles" {
    type = list(string)
    description = "(Optional) A list of role IDs excluded from scope of policy."
    default = null
}

variable "excluded_users" {
    type = list(string)
    description = "(Optional) A list of user IDs excluded from scope of policy and/or GuestsOrExternalUsers."
    default = null
}

variable "included_groups" {
    type = list(string)
    description = "(Optional) A list of group IDs in scope of policy unless explicitly excluded."
    default = null
}

variable "included_roles" {
    type = list(string)
    description = "(Optional) A list of role IDs in scope of policy unless explicitly excluded."
    default = null
}

variable "included_users" {
    type = list(string)
    description = "(Optional) A list of user IDs in scope of policy unless explicitly excluded, or None or All or GuestsOrExternalUsers."
    default = null
}

################
# Grant Controls
################


################
# Session Controls
################
