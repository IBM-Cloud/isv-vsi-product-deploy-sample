##############################################################################
# This is default entrypoint.
#  - Ensure user provided region is valid
#  - Ensure user provided resource_group is valid
##############################################################################
provider "ibm" {
  /* Uncomment ibmcloud_api_key while testing from CLI */
  //ibmcloud_api_key      = var.api_key
  generation            = 2 
  region                = var.region
  ibmcloud_timeout      = 300
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
data "ibm_is_subnet" "vsi_subnet"{
   identifier = var.subnet_id
}

##############################################################################
# Create Ubuntu 18.04 virtual server.
##############################################################################

//security group
resource "ibm_is_security_group" "vsi_security_group" {
  name           = var.vsi_security_group
  vpc            = data.ibm_is_subnet.vsi_subnet.vpc
  resource_group = data.ibm_is_subnet.vsi_subnet.resource_group
}

//security group rule to allow ssh
resource "ibm_is_security_group_rule" "vsi_sg_allow_ssh" {
  depends_on = [ibm_is_security_group.vsi_security_group]
  group     = ibm_is_security_group.vsi_security_group.id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

//security group rule to allow all for inbound
resource "ibm_is_security_group_rule" "vsi_sg_rule_in_all" {
  depends_on = [ibm_is_security_group_rule.vsi_sg_allow_ssh]
  group     = ibm_is_security_group.vsi_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
}

//security group rule to allow all for outbound
resource "ibm_is_security_group_rule" "vsi_sg_rule_out_all" {
  depends_on = [ibm_is_security_group_rule.vsi_sg_rule_in_all]
  group     = ibm_is_security_group.vsi_security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}
 
//vsi instance 
resource "ibm_is_instance" "sample_vsi" {
  depends_on = [ibm_is_security_group_rule.vsi_sg_rule_out_all]
  name           = var.vsi_instance_name
  image          = local.image_map[var.region]
  profile        = data.ibm_is_instance_profile.vsi_profile.name
  resource_group = data.ibm_is_subnet.vsi_subnet.resource_group

  primary_network_interface {
    name = "eth0"
    subnet = data.ibm_is_subnet.vsi_subnet.id
    security_groups = [ibm_is_security_group.vsi_security_group.id]
  }
  
  vpc  = data.ibm_is_subnet.vsi_subnet.vpc
  zone = data.ibm_is_subnet.vsi_subnet.zone
  keys = [data.ibm_is_ssh_key.vsi_ssh_pub_key.id]
}


