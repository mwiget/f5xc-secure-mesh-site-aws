resource "restapi_object" "secure_mesh_site_1" {
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/securemesh_sites"
  data         = local.aws1
}

module "aws1" {
  depends_on       = [ restapi_object.secure_mesh_site_1 ]
  source           = "./modules/f5xc/ce/aws"
  f5xc_tenant      = var.f5xc_tenant
  f5xc_api_url     = var.f5xc_api_url
  f5xc_namespace   = var.f5xc_namespace
  f5xc_api_token   = var.f5xc_api_token
  # f5xc_api_ca_cert = var.f5xc_api_ca_cert

  owner_tag             = var.owner
  has_public_ip         = true
  is_sensitive          = false
  aws_vpc_cidr_block    = "192.168.0.0/20"
  f5xc_aws_vpc_az_nodes = {
    node0 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.0/26",
      f5xc_aws_vpc_az_name    = format("%s%s", "eu-south-1", "a")
    },
    node1 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.64/26",
      f5xc_aws_vpc_az_name    = format("%s%s", "eu-south-1", "b")
    },
    node2 = {
      f5xc_aws_vpc_slo_subnet = "192.168.0.128/26",
      f5xc_aws_vpc_az_name    = format("%s%s", "eu-south-1", "c")
    }
  }
  aws_security_group_rules_slo_ingress = []
  aws_security_group_rules_slo_egress = []
  f5xc_ce_gateway_type   = "ingress_gateway"
  f5xc_token_name        = format("%s-aws1", var.project_prefix)
  f5xc_aws_region        = "eu-south-1"
  f5xc_cluster_latitude  = "45.4"
  f5xc_cluster_longitude = "9.18"
  f5xc_cluster_name      = format("%s-aws1", var.project_prefix)
  f5xc_cluster_labels    = { "site-mesh" : format("%s", var.project_prefix) }
  ssh_public_key         = file(var.ssh_public_key_file)
  providers              = {
    aws      = aws.eu-south-1
  }
}

locals {
  aws1 = jsonencode({
    "metadata" : {
      "name" : format("%s-aws1", var.project_prefix)
      "namespace" : "system",
      "labels" : {
        "site-mesh" : var.project_prefix
      },
      "annotations" : {},
      "disable" : false
    },
    "spec" : {
      "volterra_certified_hw" : "aws-byol-voltmesh",
      "master_node_configuration" : [
        {
          "name" : format("%s-aws1-node0", var.project_prefix)
        },
        {
          "name" : format("%s-aws1-node1", var.project_prefix)
        },
        {
          "name" : format("%s-aws1-node2", var.project_prefix)
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

output "secure_mesh_site_1" {
  value = restapi_object.secure_mesh_site_1.api_response
}

output "aws1" {
  value = module.aws1
}
