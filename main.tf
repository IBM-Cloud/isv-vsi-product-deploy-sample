##############################################################################
# This is default entrypoint.
#  - Ensure user provided region is valid
#  - Ensure user provided resource_group is valid
##############################################################################
provider "ibm" {
  /* Uncomment ibmcloud_api_key while testing from CLI */
  //ibmcloud_api_key      = var.api_key
  generation       = 2
  region           = var.region
  ibmcloud_timeout = 300
}

##############################################################################
# Read/validate Region
##############################################################################
data "ibm_is_region" "region" {
  name = var.region
}

##############################################################################
# This file creates the compute instances for the solution.
# - Virtual Server using custom image id
##############################################################################

##############################################################################
# Read/validate sshkey
##############################################################################
data "ibm_is_ssh_key" "vsi_ssh_pub_key" {
  name = var.ssh_key_name
}

##############################################################################
# Read/validate vsi profile
##############################################################################
data "ibm_is_instance_profile" "vsi_profile" {
  name = var.vsi_profile
}

##############################################################################
#  - Read/validate subnet
##############################################################################
data "ibm_is_subnet" "vsi_subnet" {
  identifier = var.subnet_id
}

##############################################################################
# Create Ubuntu 18.04 virtual server.
##############################################################################

locals {
  rules = [
    for r in var.security_group_rules : {
      name       = r.name
      direction  = r.direction
      remote     = lookup(r, "remote", null)
      ip_version = lookup(r, "ip_version", null)
      icmp       = lookup(r, "icmp", null)
      tcp        = lookup(r, "tcp", null)
      udp        = lookup(r, "udp", null)
    }
  ]
}

module "security_group" {
  source = "terraform-ibm-modules/vpc/ibm//modules/security-group"

  vpc_id                = data.ibm_is_subnet.vsi_subnet.vpc
  resource_group_id     = data.ibm_is_subnet.vsi_subnet.resource_group
  create_security_group = true
  name                  = var.vsi_security_group
  security_group_rules  = local.rules
}

locals {
  primary_network_interface = [
    {
      interface_name       = "eth0"
      subnet               = data.ibm_is_subnet.vsi_subnet.id
      security_groups      = module.security_group.security_group_id
      primary_ipv4_address = ""
    },
  ]
}

module "instance" {
  source = "terraform-ibm-modules/vpc/ibm//modules/instance"

  name                      = var.vsi_instance_name
  vpc_id                    = data.ibm_is_subnet.vsi_subnet.vpc
  resource_group_id         = data.ibm_is_subnet.vsi_subnet.resource_group
  location                  = data.ibm_is_subnet.vsi_subnet.zone
  image                     = local.image_map[var.region]
  profile                   = data.ibm_is_instance_profile.vsi_profile.name
  ssh_keys                  = [data.ibm_is_ssh_key.vsi_ssh_pub_key.id]
  primary_network_interface = local.primary_network_interface

  depends_on = [module.security_group]
}