resource "google_compute_region_network_firewall_policy_with_rules" "compute_region_network_firewall_policy_with_rules" {
  for_each = var.compute_region_network_firewall_policy_with_rules

  name            = each.value.name
  deletion_policy = each.value.deletion_policy
  description     = each.value.description
  policy_type     = each.value.policy_type
  project         = each.value.project
  region          = each.value.region

  dynamic "rule" {
    for_each = each.value.rule
    content {
      action         = rule.value.action
      description    = rule.value.description
      direction      = rule.value.direction
      disabled       = rule.value.disabled
      enable_logging = rule.value.enable_logging
      match {
        dest_address_groups       = rule.value.match.dest_address_groups
        dest_fqdns                = rule.value.match.dest_fqdns
        dest_ip_ranges            = rule.value.match.dest_ip_ranges
        dest_region_codes         = rule.value.match.dest_region_codes
        dest_threat_intelligences = rule.value.match.dest_threat_intelligences
        dynamic "layer4_config" {
          for_each = rule.value.match.layer4_config
          content {
            ip_protocol = layer4_config.value.ip_protocol
            ports       = layer4_config.value.ports
          }
        }
        src_address_groups = rule.value.match.src_address_groups
        src_fqdns          = rule.value.match.src_fqdns
        src_ip_ranges      = rule.value.match.src_ip_ranges
        src_region_codes   = rule.value.match.src_region_codes
        dynamic "src_secure_tag" {
          for_each = rule.value.match.src_secure_tag != null ? rule.value.match.src_secure_tag : []
          content {
            name = src_secure_tag.value.name
          }
        }
        src_threat_intelligences = rule.value.match.src_threat_intelligences
      }
      priority                = rule.value.priority
      rule_name               = rule.value.rule_name
      security_profile_group  = rule.value.security_profile_group
      target_forwarding_rules = rule.value.target_forwarding_rules
      dynamic "target_secure_tag" {
        for_each = rule.value.target_secure_tag != null ? rule.value.target_secure_tag : []
        content {
          name = target_secure_tag.value.name
        }
      }
      target_service_accounts = rule.value.target_service_accounts
      target_type             = rule.value.target_type
      tls_inspect             = rule.value.tls_inspect
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

