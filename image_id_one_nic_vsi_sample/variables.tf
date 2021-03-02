##############################################################################
# Variable block - See each variable description
##############################################################################


##############################################################################
# subnet_id - Subnet where resources are to be provisioned.
##############################################################################
variable "subnet_id"{
  default = ""
  description = "The id of the subnet to which VSI's interface belongs to"
}

##############################################################################
# ssh_key_name - The name of the public SSH key to be used when provisining VSI.
##############################################################################
variable "ssh_key_name" {
  default     = ""
  description = "The name of the public SSH key to be used when provisining VSI."
}

##############################################################################
# vsi_instance_name - The name of your Virtual Server to be provisioned
##############################################################################
variable "vsi_instance_name" {
  default     = "sample-vsi"
  description = "The name of your Virtual Server to be provisioned."
}

##############################################################################
# vsi_profile - The profile of compute CPU and memory resources to be used when provisioning VSI.
##############################################################################
variable "vsi_profile" {
  default     = "bx2-2x8"
  description = "The profile of compute CPU and memory resources to be used when provisioning VSI. To list available profiles, run `ibmcloud is instance-profiles`."
}

variable "region" {
  default     = "us-south"
  description = "Optional. The value of the region of VPC."
}

#####################################################################################################
# api_key - This is the ibm_cloud_api_key which should be used only while testing this code from CLI. 
# It is not needed while testing from Schematics
######################################################################################################
/*variable "api_key" {
  default     = ""
  description = "holds the user api key"
}*/

##############################################################################
# vsi_securtiy_group - The security group to which the VSI interface belongs to.
##############################################################################
variable "vsi_security_group" {
  default     = "sample-security-group"
  description = "The security group for VSI"
}
