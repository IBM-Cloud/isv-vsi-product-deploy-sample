# Description
This directory contains the sample terraform code to create a virtual server instance (VSI) image. 

# Prerequisites

  1. Create an IBM Cloud Object Storage bucket and upload the `qcow2` image, which will be used to create a custom image in your account. For more information, see the following links:
    
  * [Getting started with Cloud Object Storage](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-getting-started-cloud-object-storage)
  * [Images](https://cloud.ibm.com/docs/vpc?topic=vpc-about-images)
  
  2. Create a Virtual Private Cloud (VPC) and subnet. For more information, see [Getting started with VPC](https://cloud.ibm.com/docs/vpc?topic=vpc-getting-started).  
  3. Create a [SSH key](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys). 
  4. Create a [virtual server instance](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-virtual-servers).   

# Import your custom image to all supported regions

When you are ready to make your image publicly available, import your image to every region in which you want your solution to be available. The following API example shows how to use a single IBM Cloud Object Storage bucket. Make sure the image name is unique and the same value across all regions. Record the image ID that's returned for each image. 

**Tip**: Images are regional, so a different image ID is used for each region.


```curl -X POST -k -Ss "<region endpoint>/v1/images?generation=2&version=2021-02-26" -H "Authorization: Bearer <IAM token>"  -d '{ "name": "myimage", "file": {"href": "cos://us-south/my-bucket/myimage.qcow2"}, "operating_system": { "name": "centos-8-amd64"} } '  |  jq .```

**Response**:
```
{
  "id": "r134-e2a3594d-eef0-4e20-bbcb-d9ca8a2fc9fa",
  "crn": "crn:v1:staging:public:is:us-south:a/<removed>::image:r134-e2a3594d-eef0-4e20-bbcb-d9ca8a2fc9fa",
  "href": "https://us-south-genesis-test02.iaasdev.cloud.ibm.com/v1/images/r134-e2a3594d-eef0-4e20-bbcb-d9ca8a2fc9fa",
  "name": "myimage",
  "resource_group": {
    "id": "<removed>",
    "href": "https://resource-controller.test.cloud.ibm.com/v1/resource_groups/<removed>"
  },
  "created_at": "2021-02-26T15:19:08Z",
  "file": {},
  "operating_system": {
    "href": "https://us-south-genesis-test02.iaasdev.cloud.ibm.com/v1/operating_systems/centos-8-amd64",
    "name": "centos-8-amd64",
    "architecture": "amd64",
    "display_name": "CentOS 8.x - Minimal Install (amd64)",
    "family": "CentOS",
    "vendor": "CentOS",
    "version": "8.x - Minimal Install",
    "dedicated_host_only": false
  },
  "status": "pending",
  "visibility": "private",
  "encryption": "none",
  "status_reasons": []
}
```

The image status will transition from pending to available after several minutes. To check the status, see the following example:

```
curl -k -sS -X GET "<region endpoint>/v1/images/<image id>?generation=2&limit=100&version=2021-02-26" -H "Authorization: Bearer <IAM token>"  | jq .
{
  "id": "r134-e2a3594d-eef0-4e20-bbcb-d9ca8a2fc9fa",
  "crn": "crn:v1:staging:public:is:us-south:a/<removed>::image:r134-e2a3594d-eef0-4e20-bbcb-d9ca8a2fc9fa",
  "href": "https://us-south-genesis-test02.iaasdev.cloud.ibm.com/v1/images/r134-e2a3594d-eef0-4e20-bbcb-d9ca8a2fc9fa",
  "name": "myimage",
  "resource_group": {
    "id": "<removed>",
    "href": "https://resource-controller.test.cloud.ibm.com/v1/resource_groups/<removed>"
  },
  "created_at": "2021-02-26T15:19:08Z",
  "file": {},
  "operating_system": {
    "href": "https://us-south-genesis-test02.iaasdev.cloud.ibm.com/v1/operating_systems/centos-8-amd64",
    "name": "centos-8-amd64",
    "architecture": "amd64",
    "display_name": "CentOS 8.x - Minimal Install (amd64)",
    "family": "CentOS",
    "vendor": "CentOS",
    "version": "8.x - Minimal Install",
    "dedicated_host_only": false
  },
  "status": "available",
  "visibility": "private",
  "encryption": "none",
  "status_reasons": []
}
```

The region endpoint can be derived by using the /regions API as shown in the following example:

```
curl -k -sS -X GET "<region endpoint>/v1/regions?generation=2&version=2021-02-26" -H "Authorization: Bearer <IAM token>"  | jq .
{
  "regions": [
    {
      "name": "au-syd",
      "href": "https://us-south.iaas.cloud.ibm.com/v1/regions/au-syd",
      "endpoint": "https://au-syd.iaas.cloud.ibm.com",
      "status": "available"
    },
    {
      "name": "eu-de",
      "href": "https://us-south.iaas.cloud.ibm.com/v1/regions/eu-de",
      "endpoint": "https://eu-de.iaas.cloud.ibm.com",
      "status": "available"
    },
    {
      "name": "eu-gb",
      "href": "https://us-south.iaas.cloud.ibm.com/v1/regions/eu-gb",
      "endpoint": "https://eu-gb.iaas.cloud.ibm.com",
      "status": "available"
    },
    {
      "name": "jp-osa",
      "href": "https://us-south.iaas.cloud.ibm.com/v1/regions/jp-osa",
      "endpoint": "https://jp-osa.iaas.cloud.ibm.com",
      "status": "available"
    },
    {
      "name": "jp-tok",
      "href": "https://us-south.iaas.cloud.ibm.com/v1/regions/jp-tok",
      "endpoint": "https://jp-tok.iaas.cloud.ibm.com",
      "status": "available"
    },
    {
      "name": "us-east",
      "href": "https://us-south.iaas.cloud.ibm.com/v1/regions/us-east",
      "endpoint": "https://us-east.iaas.cloud.ibm.com",
      "status": "available"
    },
    {
      "name": "us-south",
      "href": "https://us-south.iaas.cloud.ibm.com/v1/regions/us-south",
      "endpoint": "https://us-south.iaas.cloud.ibm.com",
      "status": "available"
    }
  ]
}
```

You now have private images in each desired region.   
  
# Create your Terraform template

Before you begin, make sure that you have the following IBM Cloud Identity and Access Management (IAM) permissions:

 * Manager service access role for IBM Cloud Schematics
 * Operator platform role for VPC Infrastructure

For the detailed steps, see [Creating Terraform templates](https://cloud.ibm.com/docs/schematics?topic=schematics-create-tf-config).  

# Test your Terraform template

Test with regular TF CLI.

# Create GIT release for artifacts and .tgz

# Onboard to private catalog and validate

For details, see https://test.cloud.ibm.com/docs/third-party?topic=third-party-sw-validate.

# Make your image public (patch API)

**Note**: You can make your image public only after you validate your Terraform template, and IBM has granted you access to run the command.

_CB notes:_
  
  * Need to note that using the API is limited to vendor accounts that are added to the specific allowlist.
  * Add details about how to contact the concierge team if they need help.

The REST API supports patching the visibility of the image to 'public'.  Note that this will effectively make the image usable by any other IBM Cloud account, however, the image will not actually be visible to other accounts.  Your image will not be discoverable via the API.  In order to provision a VSI using the image, the image ID needs to be known.  
  
To patch the visibility of the image:
```
curl  -X PATCH "<region endpoint>/v1/images/<image id>?generation=2&version=2021-02-26"  -H "Authorization: Bearer <IAM token>" -d '{"visibility": "public"} ' | jq .
```



-------------------------------------------------- below is all from previous version -------------------

# image_one_nic_vsi_sample

This directory contains the sample terraform code to create a Ubuntu VSI Instance. The user has to ensure that the input image name exists in all regions.  

## Costs

When you apply template, the infrastructure resources that you create incur charges as follows. To clean up the resources, you can [delete your Schematics workspace or your instance](https://cloud.ibm.com/docs/schematics?topic=schematics-manage-lifecycle#destroy-resources). Removing the workspace or the instance cannot be undone. Make sure that you back up any data that you must keep before you start the deletion process.


* _VPC_: VPC charges are incurred for the infrastructure resources within the VPC, as well as network traffic for internet data transfer. For more information, see [Pricing for VPC](https://cloud.ibm.com/docs/vpc-on-classic?topic=vpc-on-classic-pricing-for-vpc).
* _VPC Custom Image_: The template will copy over a custom image - this can be a one time operation.  Virtual instances can be created from the custom image.  VPC charges per custom image.

## Dependencies

Before you can apply the template in IBM Cloud, complete the following steps.

1.  Ensure that you have the following permissions in IBM Cloud Identity and Access Management:
    * `Manager` service access role for IBM Cloud Schematics
    * `Operator` platform role for VPC Infrastructure
2.  Ensure the following resources exist in your VPC Gen 2 environment
    - VPC
    - SSH Key
    - VPC has a primary subnet
    - _(Optional):_ A Floating IP Address to assign to the management interface of Ubuntu 18.04 instance post deployment

## Configuring your deployment values

Create a schematics workspace and provide the github repository url (https://github.com/IBM-Cloud/isv-vsi-product-deploy-sample) under settings to pull the latest code, so that you can set up your deployment variables from the `Create` page. Once the template is applied, IBM Cloud Schematics  provisions the resources based on the values that were specified for the deployment variables.

### Required values
Fill in the following values, based on the steps that you completed before you began.

| Key | Definition | Value Example |
| --- | ---------- | ------------- | 
| `generation` | The VPC Generation 2 that you want your VPC virtual servers to be provisioned.  | 2  |
| `region` | The VPC region that you want your VPC virtual servers to be provisioned. | us-south |
| `image_name` | The name of the image that you want your VPC virtual servers to be provisioned. | ibm-ubuntu-20-04-minimal-amd64-2 |
| `ssh_key_name` | The name of your public SSH key to be used for VSI. Follow [Public SSH Key Doc](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys) for creating and managing ssh key. | sample-ssh-key |
| `vsi_profile` | The profile of compute CPU and memory resources to be used when provisioning the vsi instance. To list available profiles, run `ibmcloud is instance-profiles`. | bx2-2x8 |
| `vsi_instance_name` | The name of the VSI instance to be provisioned. | sample-vsi |
| `subnet_id` | The ID of the subnet which will be associated with first interface of the VSI instance. Click on the subnet details in the VPC Subnet Listing to determine this value | 0717-xxxxxx-xxxx-xxxxx-8fae-xxxxx |
| `vsi_security_group` | The name of the security group to which the VSI Instance's interface belong to | sample-security-group |  

## Notes

If there is any failure during VSI creation, the created resources must be destroyed before attempting to instantiate again. To destroy resources go to `Schematics -> Workspaces -> [Your Workspace] -> Actions -> Delete` to delete  all associated resources. <br/>

# Post Ubuntu VSI Instance Spin-up

1. From the VPC list, confirm the Ubuntu VSI is powered ON with green button
2. Assign a Floating IP to the Ubuntu-VSI. Refer the steps below to associate floating IP
    - Go to `VPC Infrastructure Gen 2` from IBM Cloud
    - Click `Floating IPs` from the left pane
    - Click `Reserve floating IP` -> Click `Reserve IP`
    - There will be a (new) Floating IP address with status `Unbind`
    - Click Three Dot Button corresponding to the Unbound IP address -> Click `Bind`
    - Select Ubuntu instance (eth0) from `Instance to bind` column.
    - After clicking `Bind`, you can see the IP address assigned to your Ubuntu-VSI Instance.
3. From the CLI, run `ssh root@<Floating IP>`. 
4. Enter 'yes' for continue connecting using ssh your key. This is the ssh key value, you specified in ssh_key variable. 

