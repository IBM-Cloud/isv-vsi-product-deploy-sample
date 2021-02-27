##############################################################################
# This file creates custom image using qcow2 image hosted in COS
#
##############################################################################


# Generating random ID
resource "random_uuid" "test" { }

resource "ibm_is_image" "vnf_custom_image" {
  depends_on       = ["random_uuid.test"]
  href             = "${var.vnf_cos_image_url}"
  name             = "${var.vnf_vpc_image_name}-${substr(random_uuid.test.result,0,8)}"
  operating_system = "red-7-amd64"
  resource_group = "${data.ibm_is_subnet.vnf_subnet.resource_group}"

  timeouts {
    create = "30m"
    delete = "10m"
  }
}
