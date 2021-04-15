# Description
This directory contains the sample Terraform code to create a virtual server instance image. 

# Prerequisites

  1. Create an IBM Cloud Object Storage bucket and upload the `qcow2` image, which will be used to create a custom image in your account. For more information, see the following links:
    
   * [Getting started with Cloud Object Storage](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-getting-started-cloud-object-storage)
   * [Images](https://cloud.ibm.com/docs/vpc?topic=vpc-about-images)
  
  2. Create a Virtual Private Cloud (VPC) and subnet. For more information, see [Getting started with VPC](https://cloud.ibm.com/docs/vpc?topic=vpc-getting-started).  
  3. Create a [SSH key](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys). 
  4. Create a [virtual server instance](https://cloud.ibm.com/docs/vpc?topic=vpc-creating-virtual-servers).   

# Import your custom image to all supported regions

When you are ready to make your image publicly available, import it to every region in which you want your solution to be available. The region endpoint URL can be derived by using the /regions API as shown in the following example:

**Note**: You will need to acquire a bearer token before making the API call. One way to do this is to use the command `ibmcloud iam oauth-tokens`.

```
export iam_token=<your bearer token>
curl -k -sS -X GET "https://us-south.iaas.cloud.ibm.com/v1/regions?generation=2&version=2021-02-26" -H "Authorization: Bearer $iam_token"  | jq .
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


The following API example shows how to use a single IBM Cloud Object Storage bucket. 

The image name is unique and they are regional, the same image has a different image ID in each region. In this example, the various image IDs corresponding to each region for image name `ubuntu-18-04-1-minimal-amd64-2` are specified in `image-map.tf` file. When a user specifies the region in which to create the virtual server instance, the corresponding image ID for that region is fetched. The image IDs that are mentioned in the `image-map.tf` are for the public cloud. 

```
# issue this for each region endpoint as derived from the preceding list. Update the setting for api_endpoint and then issue the curl command.
export api_endpoint="https://us-south.iaas.cloud.ibm.com"
curl -X POST -k -Ss "$api_endpoint/v1/images?generation=2&version=2021-02-26" -H "Authorization: Bearer $iam_token"  -d '{ "name": "ibm-ubuntu-18-04-1-minimal-amd64-2", "file": {"href": "cos://us-south/my-bucket/myimage.qcow2"}, "operating_system": { "name": "centos-8-amd64"} } '  |  jq .
```

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

The image status will transition from pending to available after several minutes. To check the status: 

1. Change the API endpoint to the desired region: `export api_endpoint="https://us-south.iaas.cloud.ibm.com"`
2. Set the image ID to the value that is returned in the preceding example for the region (`api_endpoint`) that you want to check: `export image_id=<image id returned for this region>`
3. Run the following command:

```
curl -k -sS -X GET "$api_endpoint/v1/images/$image_id?generation=2&limit=100&version=2021-02-26" -H "Authorization: Bearer $iam_token"  | jq .
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

To test your template, run the following commands from the Terraform CLI: 

* `terraform init`
* `terraform validate`

For more information, see [Terraform and the IBM Cloud provider plug-in](https://cloud.ibm.com/docs/ibm-cloud-provider-for-terraform?topic=ibm-cloud-provider-for-terraform-setup_cli).

# Upload your Terraform template to a GitHub release

Use the [latest isv-vsi-product-deploy-sample release](https://github.com/IBM-Cloud/isv-vsi-product-deploy-sample/releases) as an example of how to set up your release. 

**Tip**: Make sure to note the URL of your `.tgz` file.

# Onboard your Terraform template to the IBM Cloud catalog

The onboarding process includes importing your `.tgz` file that you created in the previous section to a private catalog, configuring the deployment values, and then validating the Terraform template. For more details, see [Onboarding a virtual server image](https://cloud.ibm.com/docs/third-party?topic=third-party-vsimage-onboard).

# Update the visibility of your image (patch API)

You can make your virtual server image public only after you validate your Terraform template, and IBM Cloud has granted you access to the REST API you use to update the image visibility. If you run into issues, you can contact us by going **Partner Center** > **My products** > **Help icon**. 

**Important**: The ability to patch the visibility of an image is beta functionality and is subject to change. 

The REST API supports patching the visibility of the virtual server image to `public`. You are required to run the command in every applicable region and use the image ID that's unique to each region as previously described. Note that this effectively makes the image usable by any other IBM Cloud account, however, the image is not actually visible to other accounts. Your image is not discoverable by way of the API. To create a virtual server instance by using the image, the image ID needs to be known.  

To update the visibility of the image, complete the following steps:

1. Change the API endpoint to the desired region: `export api_endpoint="https://us-south.iaas.cloud.ibm.com"`.
2. Set the image ID to the value that is returned in the preceding example for the region (`api_endpoint`) that you want to check: `export image_id=<image id returned for this region>`.
3. Run the following command:

```
curl  -X PATCH "$api_endpoint/v1/images/$image_id?generation=2&version=2021-02-26"  -H "Authorization: Bearer $iam_token" -d '{"visibility": "public"} ' | jq .
```

# Publishing a new version

To publish a new version of your image, complete the following steps: 

1. Import the new version as described in the previous Import your custom image to all supported regions section.
2. Edit the `variables.tf` file by updating the image_name variable. 
3. Create an updated GitHub release to create a new `.tgz` file, and note the new URL as previously described in the Create GIT release for artifacts and .tgz section.
4. Onboard the new version in your private catalog as previously described in the Onboard your Terraform template section. 
5. Make your image public as previously described. 

(Optional) To deprecate a previous version, complete the following steps:
  
 1. Revert the image to being private:

  ```
  curl  -X PATCH "$api_endpoint/v1/images/$image_id?generation=2&version=2021-02-26"  -H "Authorization: Bearer $iam_token" -d '{"visibility": "private"} ' | jq .

  ```
  
 2. Delete the image:
  
  ```
  curl  -X DELETE "$api_endpoint/v1/images/$image_id?generation=2&version=2021-02-26"  -H "Authorization: Bearer $iam_token" | jq .
  ```

**Note**: Run the commands in each region to ensure that you deprecate the previous version in all regions.
  
  



