# image_id_one_nic_vsi_sample

This directory contains the sample terraform code to create a VSI Instance with custom image id provided as input. 

# IBM Cloud IaaS Support
You're provided free technical support through the IBM Cloud™ community and Stack Overflow, which you can access from the Support Center. The level of support that you select determines the severity that you can assign to support cases and your level of access to the tools available in the Support Center. Choose a Basic, Advanced, or Premium support plan to customize your IBM Cloud™ support experience for your business needs.

Learn more: https://www.ibm.com/cloud/support

## Prerequisites

- Have access to [Gen 2 VPC](https://cloud.ibm.com/vpc-ext/).
- The given VPC must have at least one subnet with one IP address unassigned in each subnet - the VSI will be assigned an IP Address in its primary network interface from the user provided subnet as the input.
- Create a **Publicly Accessible** Cloud Object Storage (COS) Bucket and upload the qcow2 image using
the methods described in _IBM COS getting started docs_ (https://test.cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-getting-started). This qcow2 image will be used to create a
custom image (https://cloud.ibm.com/docs/vpc?topic=vpc-managing-images) in the 
customer account by the terraform script. It's recommended to delete the
custom image after the VSI is created by terraform.

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

Create a schematics workspace and provide the github repository url (https://github.com/IBM-Cloud/vnf-samples/multi_nic_vsi_sample) under settings to pull the latest code, so that you can set up your deployment variables from the `Create` page. Once the template is applied, IBM Cloud Schematics  provisions the resources based on the values that were specified for the deployment variables.

### Required values
Fill in the following values, based on the steps that you completed before you began.

| Key | Definition | Value Example |
| --- | ---------- | ------------- | 
| `generation` | The VPC Generation 1 (classic) or Generation 2 that you want your VPC virtual servers to be provisioned.  | 2  |
| `region` | The VPC region that you want your VPC virtual servers to be provisioned. | us-south |
| `ssh_key_name` | The name of your public SSH key to be used for VSI. Follow [Public SSH Key Doc](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-ssh-keys) for creating and managing ssh key. | sample-ssh-key |
| `vsi_image_id` | The image id of the VSI to be provisioned in your IBM Cloud account. | r001-900-000-000 |
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

