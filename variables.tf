variable "compute_region_network_firewall_policy_with_rules" {
  description = <<EOT
Map of compute_region_network_firewall_policy_with_rules, attributes below
Required:
    - name
    - rule (block):
        - action (required)
        - description (optional)
        - direction (optional)
        - disabled (optional)
        - enable_logging (optional)
        - match (required, block):
            - dest_address_groups (optional)
            - dest_fqdns (optional)
            - dest_ip_ranges (optional)
            - dest_region_codes (optional)
            - dest_threat_intelligences (optional)
            - layer4_config (required, block):
                - ip_protocol (required)
                - ports (optional)
            - src_address_groups (optional)
            - src_fqdns (optional)
            - src_ip_ranges (optional)
            - src_region_codes (optional)
            - src_secure_tag (optional, block):
                - name (optional)
            - src_threat_intelligences (optional)
        - priority (required)
        - rule_name (optional)
        - security_profile_group (optional)
        - target_forwarding_rules (optional)
        - target_secure_tag (optional, block):
            - name (optional)
        - target_service_accounts (optional)
        - target_type (optional)
        - tls_inspect (optional)
Optional:
    - deletion_policy
    - description
    - policy_type
    - project
    - region
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    name            = string
    deletion_policy = optional(string)
    description     = optional(string)
    policy_type     = optional(string)
    project         = optional(string)
    region          = optional(string)
    rule = list(object({
      action         = string
      description    = optional(string)
      direction      = optional(string)
      disabled       = optional(bool)
      enable_logging = optional(bool)
      match = object({
        dest_address_groups       = optional(list(string))
        dest_fqdns                = optional(list(string))
        dest_ip_ranges            = optional(list(string))
        dest_region_codes         = optional(list(string))
        dest_threat_intelligences = optional(list(string))
        layer4_config = list(object({
          ip_protocol = string
          ports       = optional(list(string))
        }))
        src_address_groups = optional(list(string))
        src_fqdns          = optional(list(string))
        src_ip_ranges      = optional(list(string))
        src_region_codes   = optional(list(string))
        src_secure_tag = optional(list(object({
          name = optional(string)
        })))
        src_threat_intelligences = optional(list(string))
      })
      priority                = number
      rule_name               = optional(string)
      security_profile_group  = optional(string)
      target_forwarding_rules = optional(list(string))
      target_secure_tag = optional(list(object({
        name = optional(string)
      })))
      target_service_accounts = optional(list(string))
      target_type             = optional(string)
      tls_inspect             = optional(bool)
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.compute_region_network_firewall_policy_with_rules : (
        length(v.rule) >= 1
      )
    ])
    error_message = "Each rule list must contain at least 1 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.compute_region_network_firewall_policy_with_rules : (
        alltrue([for item in v.rule : (length(item.match.layer4_config) >= 1)])
      )
    ])
    error_message = "Each layer4_config list must contain at least 1 items"
  }
  # Note: 3 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

