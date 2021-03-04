# isv-vsi-product-deploy-sample
Templated for any IBM 3rd party vendor, that wishes to be part of IBM Cloud

This repository contains sample terraform codes to create VSI instances with different scenarios like Single NIC Instance using a custom COS image, image id, etc.

The different scenarios for which the sample code are available are:

| Scenario | Description | URL |
|----------|-------------|-----|
| Using custom COS image one nic vsi | Contains the sample terraform code to create a VSI Instance with a single network interface using a custom cos image. | https://github.com/IBM-Cloud/isv-vsi-product-deploy-sample/tree/master/custom_cos_image_one_nic_vsi_sample/ | 
| Using catalog image id one nic vsi | Contains the sample terraform code to create a VSI Instance with a single network interface using a catalog image id as input. | https://github.com/IBM-Cloud/isv-vsi-product-deploy-sample/tree/master/image_id_one_nic_vsi_sample/  |


# Testing Sample Code 

Each of these scenarios can be tested using Terraform CLI commands and IBM Cloud Schematics.

  (1) To test it from IBM Cloud Schematics, the path of the directory in this github repository need to be provided as the URL. For example to test the custom_cos_image_one_nic_vsi_sample scenario, the URL to be used in the IBM Cloud Schematics will be https://github.com/IBM-Cloud/isv-vsi-product-deploy-sample/tree/master/custom_cos_image_one_nic_vsi_sample/. Please refer the README file of respective scenarios to know more about the values to be specified in Schematics UI.

  (2) To test the use case in CLI, change directory to the respective folder of the scenario. Example: /Users/username/isv-vsi-product-deploy-sample/custom_cos_image_one_nic_vsi_sample. Execute terraform commands in the scenario directory. 
    
    Example:   
    /Users/username/isv-vsi-product-deploy-sample/custom_cos_image_one_nic_vsi_sample> terraform init

  (3) In order to use a particular scenario in the content catalogue as a .tar.gz release file, copy the code of the specific    scenario in a separate repository and then use it as a .tar.gz release file. This repository content as such cannot be used in the content catalogue.

Follow the README for each of the scenarios to get more details.

# Create IBM Cloud Catalog Offering

To create a Terraform based IBM Cloud Catalog offering, follow the instructions in [ContentCatalog.md](ContentCatalog.md)
