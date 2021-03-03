##############################################################################
# Variable block - See each variable description
##############################################################################

##############################################################################
# vsi_cos_image_url - Vendor provided image COS url.
#                             The value for this variable is enter at offering
#                             onbaording time.This variable is hidden from the user.
##############################################################################
variable "vsi_cos_image_url" {
  default     = ""
  description = "The COS image object SQL URL for qcow2 image."
}

##############################################################################
# subnet_ids - Subnet where resources are to be provisioned.
##############################################################################
variable "subnet_id"{
  default = ""
  description =  "The id of the subnet to which VSI's primary interface belongs to"
}

##############################################################################
# ssh_key_name - The name of the public SSH key to be used when provisining VSI.
##############################################################################
variable "ssh_key_name" {
  default     = ""
  description = "The name of the public SSH key to be used when provisining VSI."
}

variable "ssh_key" {
  default     = ""
  description = "The value of the public ssh key to be used during cloud-init."
}

##############################################################################
# vsi_vpc_image_name - The name of the custom image to be provisioned in your IBM Cloud account.
##############################################################################
variable "vsi_vpc_image_name" {
  default     = "sample-custom-img"
  description = "The name of the custom image to be provisioned in your IBM Cloud account."
}

##############################################################################
# vsi_image_name - The name of your Virtual Server to be provisioned
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
# vsi_securtiy_group - The security group to which the VSI interface belongs to.
##############################################################################
variable "vsi_security_group" {
  default     = "sample-security-group"
  description = "The security group for VSI"
}

variable "TF_VERSION" {
 default = "0.12"
 description = "terraform engine version to be used in schematics"
}
