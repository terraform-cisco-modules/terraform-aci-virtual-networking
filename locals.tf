locals {
  defaults    = lookup(var.model, "defaults", {})
  VMM         = local.defaults.virtual_networking
  vmm_netflow = local.VMM.vswitch_policy.vmm_netflow_export_policies

  #__________________________________________________________
  #
  # Virtual Networking Variables
  #__________________________________________________________

  vmm_domains = {
    for i in flatten([
      for value in lookup(var.model, "virtual_networking", []) : [
        for v in value.domain : {
          access_mode = lookup(v, "access_mode", local.VMM.domain.access_mode)
          annotation = coalesce(lookup(v, "annotation", local.VMM.domain.annotation), var.annotation)
          control_knob          = lookup(v, "control_knob", local.VMM.domain.control_knob)
          delimiter             = lookup(v, "delimiter", local.VMM.domain.delimiter)
          dvs                   = value.virtual_switch_name
          enable_tag_collection = lookup(v, "enable_tag_collection", local.VMM.domain.enable_tag_collection)
          enable_vm_folder_data_retrieval = lookup(
            v, "enable_vm_folder_data_retrieval", local.VMM.domain.enable_vm_folder_data_retrieval
          )
          encapsulation           = lookup(v, "encapsulation", local.VMM.domain.encapsulation)
          endpoint_inventory_type = lookup(v, "endpoint_inventory_type", local.VMM.domain.endpoint_inventory_type)
          endpoint_retention_time = lookup(v, "endpoint_retention_time", local.VMM.domain.endpoint_retention_time)
          enforcement             = lookup(v, "enforcement", local.VMM.domain.enforcement)
          numOfUplinks            = length(lookup(v, "uplink_names", ["uplink1", "uplink2"]))
          preferred_encapsulation = lookup(v, "preferred_encapsulation", local.VMM.domain.preferred_encapsulation)
          switch_provider         = lookup(v, "switch_provider", local.VMM.domain.switch_provider)
          switch_mode             = lookup(v, "switch_mode", local.VMM.domain.switch_mode)
          uplink_names            = length(lookup(v, "uplink_names", local.VMM.domain.uplink_names)) > 0 ? v.uplink_names : ["uplink1", "uplink2"]
          vlan_pool               = v.vlan_pool
        }
      ]
    ]) : i.dvs => i
  }
  vmm_credentials = {
    for i in flatten([
      for value in lookup(var.model, "virtual_networking", []) : [
        for k, v in value.credentials : {
          annotation  = local.vmm_domains["${value.virtual_switch_name}"].annotation
          dvs         = value.virtual_switch_name
          description = lookup(v, "description", local.VMM.credentials.description)
          password    = v.password
          username    = v.username
        }
      ]
    ]) : i.dvs => i
  }
  vmm_controllers = {
    for i in flatten([
      for value in lookup(var.model, "virtual_networking", []) : [
        for v in value.controllers : {
          annotation = coalesce(lookup(v, "annotation", local.VMM.controllers.annotation
          ), var.annotation)
          datacenter     = lookup(v, "datacenter", local.VMM.controllers.datacenter)
          dvs            = value.virtual_switch_name
          dvs_version    = lookup(v, "dvs_version", local.VMM.controllers.dvs_version)
          hostname       = lookup(v, "hostname", local.VMM.controllers.hostname)
          management_epg = lookup(v, "management_epg", local.VMM.controllers.management_epg)
          mgmt_epg_type = var.management_epgs[index(var.management_epgs.*.name,
            lookup(v, "management_epg", local.VMM.controllers.management_epg))
          ].type
          monitoring_policy = lookup(v, "monitoring_policy", local.VMM.controllers.monitoring_policy)
          port              = lookup(v, "port", local.VMM.controllers.port)
          sequence_number   = lookup(v, "sequence_number", local.VMM.controllers.sequence_number)
          stats_collection  = lookup(v, "stats_collection", local.VMM.controllers.stats_collection)
          switch_mode       = lookup(value, "switch_mode", local.VMM.domain.switch_mode)
          switch_scope      = lookup(v, "switch_scope", local.VMM.controllers.switch_scope)
          trigger_inventory_sync = lookup(
            v, "trigger_inventory_sync", local.VMM.controllers.trigger_inventory_sync
          )
          vxlan_pool = lookup(v, "vxlan_pool", local.VMM.controllers.vxlan_pool)
        }
      ]
    ]) : "${i.dvs}_${i.hostname}" => i
  }
  vswitch_policies = {
    for i in flatten([
      for key, value in lookup(var.model, "virtual_networking", []) : [
        for k, v in value.vswitch_policy : {
          annotation = coalesce(lookup(v, "annotation", local.VMM.vswitch_policy.annotation
          ), var.annotation)
          cdp_interface_policy = lookup(v, "cdp_interface_policy", "")
          dvs                  = value.virtual_switch_name
          enhanced_lag_policy = length(compact(
            [lookup(lookup(v, "enhanced_lag_policy", {}), "name", "")])
            ) > 0 ? {
            load_balancing_mode = lookup(
              lookup(v, "enhanced_lag_policy", {}
            ), "load_balancing_mode", local.VMM.vswitch_policy.load_balancing_mode)
            mode = lookup(
              lookup(v, "enhanced_lag_policy", {}
            ), "mode", local.VMM.vswitch_policy.mode)
            name = lookup(
              lookup(v, "enhanced_lag_policy", {}
            ), "name", local.VMM.vswitch_policy.name)
            number_of_links = lookup(
              lookup(v, "enhanced_lag_policy", {}
            ), "number_of_links", local.VMM.vswitch_policy.number_of_links)
          } : {}
          firewall_policy       = lookup(v, "firewall_policy", "default")
          lldp_interface_policy = lookup(v, "lldp_interface_policy", "")
          mtu_policy            = lookup(v, "mtu_policy", "default")
          netflow_export_policy = length(compact([lookup(v, "netflow_export_policy", "")])) > 0 ? [
            for s in v.vmm_netflow_export_policies : {
              active_flow_timeout = lookup(s, "active_flow_timeout", local.vmm_netflow.active_flow_timeout)
              idle_flow_timeout   = lookup(s, "idle_flow_timeout", local.vmm_netflow.idle_flow_timeout)
              netflow_policy      = s.netflow_policy
              sample_rate         = lookup(s, "sample_rate", local.vmm_netflow.sample_rate)
            }
          ] : []
          port_channel_policy = lookup(v, "port_channel_policy", "")
        }
      ]
    ]) : i.dvs => i
  }
  vmm_uplinks = { for i in flatten([
    for k, v in local.vmm_domains : [
      for s in range(length(v.uplink_names)) : {
        access_mode     = v.access_mode
        dvs             = k
        switch_provider = v.switch_provider
        uplinkId        = s
        uplinkName      = element(v.uplink_names, s)
      }
    ]
    ]) : "${i.dvs}_${i.uplinkName}" => i if i.access_mode == "read-write"
  }
}
