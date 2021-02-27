##############################################################################
# Variable block - See each variable description
##############################################################################

##############################################################################
# vnf_cos_image_url - Vendor provided RHEL image COS url.
#                             The value for this variable is enter at offering
#                             onbaording time.This variable is hidden from the user.
##############################################################################
variable "vnf_cos_image_url" {
  default     = ""
  description = "The COS image object SQL URL for RHEL qcow2 image."
}

##############################################################################
# subnet_ids - Subnet where resources are to be provisioned.
##############################################################################
variable "subnet_id"{
  default = ""
  description =  "The id of the subnet to which RHEL VSI's primary interface belongs to"
}

##############################################################################
# ssh_key_name - The name of the public SSH key to be used when provisining RHEL VSI.
##############################################################################
variable "ssh_key_name" {
  default     = ""
  description = "The name of the public SSH key to be used when provisining RHEL VSI."
}

variable "ssh_key" {
  default     = ""
  description = "The value of the public ssh key to be used during cloud-init."
}

##############################################################################
# vnf_vpc_image_name - The name of the RHEL custom image to be provisioned in your IBM Cloud account.
##############################################################################
variable "vnf_vpc_image_name" {
  default     = "rhel-"
  description = "The name of the RHEL custom image to be provisioned in your IBM Cloud account."
}

##############################################################################
# vnf_vpc_image_name - The name of your RHEL Virtual Server to be provisioned
##############################################################################
variable "vnf_instance_name" {
  default     = "rhel-vsi"
  description = "The name of your RHEL Virtual Server to be provisioned."
}

##############################################################################
# vnf_profile - The profile of compute CPU and memory resources to be used when provisioning RHEL VSI.
##############################################################################
variable "vnf_profile" {
  default     = "bx2-2x8"
  description = "The profile of compute CPU and memory resources to be used when provisioning RHEL VSI. To list available profiles, run `ibmcloud is instance-profiles`."
}

variable "region" {
  default     = "us-south"
  description = "The value of the region of VPC."
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
# vnf_securtiy_group - The security group to which the VSI interface belongs to.
##############################################################################
variable "vnf_security_group" {
  default     = "rhel-security-group"
  description = "The security group for VNF VPC"
}
