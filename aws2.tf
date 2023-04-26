resource "restapi_object" "secure_mesh_site_2" {
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/securemesh_sites"
  data         = local.aws2
}

module "aws2" {
  depends_on       = [ restapi_object.secure_mesh_site_2 ]
  source           = "./modules/f5xc/ce/aws"
  f5xc_tenant      = var.f5xc_tenant
  f5xc_api_url     = var.f5xc_api_url
  f5xc_namespace   = var.f5xc_namespace
  f5xc_api_token   = var.f5xc_api_token
  # f5xc_api_ca_cert = var.f5xc_api_ca_cert

  owner_tag             = var.owner
  has_public_ip         = true
  is_sensitive          = false
  aws_vpc_cidr_block    = "192.168.16.0/23"

  f5xc_aws_vpc_az_nodes = {
    node0 = {
      f5xc_aws_vpc_slo_subnet = "192.168.16.0/26",
      f5xc_aws_vpc_sli_subnet = "192.168.17.0/26",
      f5xc_aws_vpc_az_name    = format("%s%s", "eu-north-1", "a")
    },
    node1 = {
      f5xc_aws_vpc_slo_subnet = "192.168.16.64/26",
      f5xc_aws_vpc_sli_subnet = "192.168.17.64/26",
      f5xc_aws_vpc_az_name    = format("%s%s", "eu-north-1", "b")
    },
    node2 = {
      f5xc_aws_vpc_slo_subnet = "192.168.16.128/26",
      f5xc_aws_vpc_sli_subnet = "192.168.17.128/26",
      f5xc_aws_vpc_az_name    = format("%s%s", "eu-north-1", "c")
    }
  }
  aws_security_group_rules_slo_ingress = []
  aws_security_group_rules_slo_egress = []
  aws_security_group_rules_sli_ingress = []
  aws_security_group_rules_sli_egress = []
  f5xc_ce_gateway_type   = "ingress_egress_gateway"
  f5xc_token_name        = format("%s-aws2", var.project_prefix)
  f5xc_aws_region        = "eu-north-1"
  f5xc_cluster_latitude  = "59.3"
  f5xc_cluster_longitude = "18.0"
  f5xc_cluster_name      = format("%s-aws2", var.project_prefix)
  f5xc_cluster_labels    = { "site-mesh" : format("%s", var.project_prefix) }
  ssh_public_key         = file(var.ssh_public_key_file)
  providers              = {
    aws      = aws.eu-north-1
  }
}

locals {
  aws2 = jsonencode({
    "metadata" : {
      "name" : format("%s-aws2", var.project_prefix)
      "namespace" : "system",
      "labels" : {
        "site-mesh" : var.project_prefix
      },
      "annotations" : {},
      "disable" : false
    },
    "spec" : {
      "volterra_certified_hw" : "aws-byol-multi-nic-voltmesh",
      "master_node_configuration" : [
        {
          "name" : format("%s-aws2-node0", var.project_prefix)
        },
        {
          "name" : format("%s-aws2-node1", var.project_prefix)
        },
        {
          "name" : format("%s-aws2-node2", var.project_prefix)
        }
      ],
      "worker_nodes" : [],
      "no_bond_devices" : {},
      "default_network_config": {},
      "coordinates" : {
        "latitude" : 0,
        "longitude" : 0
      },
      "logs_streaming_disabled" : {},
      "default_blocked_services" : {},
      "offline_survivability_mode" : {
        "no_offline_survivability_mode" : {}
      }
    }
  })
}

output "secure_mesh_site_2" {
  value = restapi_object.secure_mesh_site_2.api_response
}

output "aws2" {
  value = module.aws2
}
