# Description
This directory contains the sample Terraform code to create a virtual server instance (VSI) image. 

# Prerequisites

  1. Create an IBM Cloud Object Storage bucket and upload the `qcow2` image, which will be used to create a custom image in your account. For more information, see the following links:
    
   * [Getting started with Cloud Object Storage](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-getting-started-cloud-object-storage)
   * [Images](https://cloud.ibm.com/docs/vpc?topic=vpc-about-images)
  
  2. Create a Virtual Private Cloud (VPC) and subnet. For more information, see [Getting started with VPC](https://cloud.ibm.com/docs/vpc?topic=vpc-getting-started).  
  3. Create a [SSH key](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys). 
  4. Create a [virtual server instance](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-virtual-servers).   

# Import your custom image to all supported regions

When you are ready to make your image publicly available, import it to every region in which you want your solution to be available. The region endpoint can be derived by using the /regions API as shown in the following example:

**Note**: You will need to acquire a bearer token before making the API call. One way to do this is to use the command `ibmcloud iam oauth-tokens`.

```
curl -k -sS -X GET "https://us-south.iaas.cloud.ibm.com/v1/regions?generation=2&version=2021-02-26" -H "Authorization: Bearer <IAM token>"  | jq .
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


The following API example shows how to use a single IBM Cloud Object Storage bucket. Make sure the image name is unique and the same value is used across all regions. In this example the image name is `ibm-ubuntu-20-04-minimal-amd64-2`. Be sure to record the image ID that's returned for each image. 

**Tip**: Because images are regional, a different image ID is used for each region.


```curl -X POST -k -Ss "https://us-south.iaas.cloud.ibm.com/v1/images?generation=2&version=2021-02-26" -H "Authorization: Bearer <IAM token>"  -d '{ "name": "ibm-ubuntu-20-04-minimal-amd64-2", "file": {"href": "cos://us-south/my-bucket/myimage.qcow2"}, "operating_system": { "name": "centos-8-amd64"} } '  |  jq .```

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
curl -k -sS -X GET "https://us-south.iaas.cloud.ibm.com/v1/images/<image id>?generation=2&limit=100&version=2021-02-26" -H "Authorization: Bearer <IAM token>"  | jq .
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

You now have private images in each desired region.   
  
# Create your Terraform template

Before you begin, make sure that you have the following IBM Cloud Identity and Access Management (IAM) permissions:

 * Manager service access role for IBM Cloud Schematics
 * Operator platform role for VPC Infrastructure

For more details, see [Creating Terraform templates](https://cloud.ibm.com/docs/schematics?topic=schematics-create-tf-config).  

# Test your Terraform template

Use [Terraform CLI](https://www.terraform.io/docs/cli/index.html) to test your template. 

# Upload your Terraform template to a GitHub release

See [Managing releases in a repository](https://docs.github.com/en/github/administering-a-repository/managing-releases-in-a-repository). 

**Tip**: Make sure to note the URL of the `.tgz` file.

# Validate your Terraform template

The validation process includes importing your `.tgz` file that you created in the previous section to a private catalog, configuring the deployment variables, and then installing the Terraform template. For more details, see [Validating your software](https://test.cloud.ibm.com/docs/third-party?topic=third-party-sw-validate).

## Configuring your deployment values

Create a schematics workspace and provide the github repository url (https://github.com/IBM-Cloud/isv-vsi-product-deploy-sample) under settings to pull the latest code, so that you can set up your deployment variables from the `Create` page. Once the template is applied, IBM Cloud Schematics  provisions the resources based on the values that were specified for the deployment variables.

### Required deployment variables

| Deployment variables | Description | Example |
| --- | ---------- | ------------- | 
| `image_name` | The name of the image that you want your VPC virtual servers to be created. | ibm-ubuntu-20-04-minimal-amd64-2 |
| `ssh_key_name` | The name of your public SSH key to be used for VSI. See [Public SSH key](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys) for creating and managing the SSH key. | sample-ssh-key |
| `vsi_profile` | The profile of compute CPU and memory resources to be used when creating the VSI instance. To list the available profiles, run `ibmcloud is instance-profiles`. | bx2-2x8 |
| `vsi_instance_name` | The name of the VSI instance to be created. | sample-vsi |
| `subnet_id` | The ID of the subnet that's associated with first interface of the VSI instance. Click the subnet details in the VPC Subnet Listing to determine this value. | 0717-xxxxxx-xxxx-xxxxx-8fae-xxxxx |
| `vsi_security_group` | The name of the security group to which the VSI instance's interface belongs. | sample-security-group |  

# Make your VSI image public (patch API)

You can make your VSI image public only after you validate your Terraform template, and IBM Cloud has granted you access to run the command. If you run into issues, you can contact us by going **Partner Center** > **My products** > **Help icon**. 

The REST API supports patching the visibility of the VSI image to 'public'.  Note that this will effectively make the image usable by any other IBM Cloud account, however, the image will not actually be visible to other accounts.  Your image will not be discoverable via the API.  In order to provision a VSI using the image, the image ID needs to be known.  
  
To patch the visibility of the image:
```
curl  -X PATCH "https://us-south.iaas.cloud.ibm.com/v1/images/<image id>?generation=2&version=2021-02-26"  -H "Authorization: Bearer <IAM token>" -d '{"visibility": "public"} ' | jq .
```

# Updating to a new version

To release a new version of your VSI image, complete the following steps. 

1. Import the new version as described in the previous Import your custom image to all supported regions section.
2. Edit the `variables.tf` file by updating the image_name variable. 
3. Create an updated GitHub release to create a new `.tgz` file, and note the new URL as previously described in the Create GIT release for artifacts and .tgz section.
4. Validate the new version in your private catalog as previously described in the Validate your Terraform template section. 
5. Make your VSI image public as previously described. 

(Optional) To deprecate a previous version, complete the following steps:
  
 1. Revert the image to being private:

  ```
  curl  -X PATCH "https://us-south.iaas.cloud.ibm.com/v1/images/<image id>?generation=2&version=2021-02-26"  -H "Authorization: Bearer <IAM token>" -d '{"visibility": "private"} ' | jq .

  ```
  
 2. Delete the image:
  
  ```
  curl  -X DELETE "<region endpoint>/v1/images/<image id>?generation=2&version=2021-02-26"  -H "Authorization: Bearer <IAM token>" | jq .
  ```

**Note**: Run the commands in each region to ensure that you deprecate the previous version in all regions.
  
  



