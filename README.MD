# Terraform template for Splunk Enterprise on GCP
This template provisions base GCP infrastructure and deploys Splunk Enterprise (single instance). This is useful for temporary deployments used for demo/testing purposes.

### Pre-requisites
1. [Create a project in the Google Cloud Console and set up billing on that project](https://console.cloud.google.com)
2. [Install & configure gcloud CLI](https://cloud.google.com/sdk/docs/install)
3. Authenticate with gcloud via 'gcloud auth application-default login'
4. [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)
5. Set requred and optional parameters (described below)
6. Paste license in splunk-resources/license.lic

### Terraform Configurable Parameters (variables.tf)

Parameter | Description | Required?
-- | -- | --
gcp_project | The GCP project name to use | Yes
gcp_region | GCP where infrastructure will be deployed. Defaults to us-central-1 | Yes
gcp_az | GCP Availability Zone for cloud resources. Defaults to us-central1-c | Yes
privatekeypath | The path to the GCP private key ("somekey") on your local system | Yes
publickeypath | The path to your GCP public key ("somekey.pub") | Yes
cidr_range | Pool to assign IP addresses from | No
allow_cidr_range | CIDR block for incoming traffic. Defaults to all | No
machinetype | GCE instance type. Defaults to e2-medium | No
machineimage | OS base image. Defaults to CentOS 7 | No
sshuser | SSH user account of the machine image. Defaults to "centos" for the CentOS 7.x machine image | No
machinename | VM name (and internal DNS name). Defaults to "tf-splunk" | No
splunkwebport | TCP port for Splunk Web UI. Defaults to 8000 | No

### Splunk Installation Configurable Parameters (installsplunkasrootuser.sh or user-seed.conf)

Parameter | Description | Required?
--- | --- | ---
splunkuserpassword | Splunk admin password (No single quotes). Defaults to "Splunk.5". *(follow directions in install script)* | Yes
hostname | Hostname for the Splunk instance. Defaults to "Splunk" | Yes


### Usage

1. Initialize Terraform and download plugins by running `terraform init`
2. Deploy with `terraform plan` and `terraform apply`

### Accessing Splunk Web
Terraform will output the external IP address of the GCE instance. Copy & paste this URL into your web browser with ":XXXX" (no quotes) as a suffix, where XXXX is the Splunk Web port number set in the variables file (defaults to 8000). Ex. 10.10.10.10:8000

### Cleanup
To destroy the resources created by Terraform, run `terraform destroy`

This deployment template is provided for demo/POC purposes only.

### To do

