## The Scenario

I am using Terraform to provision below AWS infrastructure
- An S3 bucket
- An IAM role
- An IAM policy attached to the role that allows it to perform any S3 actions on that bucket and the objects in it
- An EC2 instance with the IAM role attached
- Output the public IP of the EC2 instance and the S3 bucket name.

## Code Walkthrough

Below is the link to the zoom recording where I have explained the code structure, best practices and a working demo.

https://drive.google.com/file/d/1UcYL7rXZ-pmkXgq7lWS5VvsBMHzEOONI/view?usp=sharing

## Code Structure
 
- I am using Terraform workspace to demonstrate infrastructure provisioning in various environment like Development, UAT, Production
- As a best practice, Terraform State file is stored in S3 bucket and DynamoDB table is used to implement state locking
- To demonstrate using Terraform Module, I have created a custom module for S3 bucket and it's associated IAM Roles and policies
- It has two subfolders, MainConfig folder has all the code to provision infrastructure. RemoteStateSetup folder has configuration to store terraform state remotely
- Inside MainConfig folder code is organized into resources.tf, outputs.tf, variables.tf and terraform.tfvars. S3 module related configuration is under Modules subfolder
- There are tfplan files for dev, uat and prod environment. 

## Installing Terraform and run the code
- Terraform Installation: Below is the link to install latest Terraform version and set PATH variable :
 https://learn.hashicorp.com/terraform/getting-started/install.html

- I have used Visual Studio Code and PowerShell, but any code editor or CLI can be used

## AWS Key Pairs

- Please crate a keypair.pem file and mention it in key_name and private_key_path variables inside variables.tf file


## Commands
- For this demo I am using environment variables to store access_key, secret_access_key and region. Below are powershell commands for the same
$env:AWS_ACCESS_KEY_ID="your access key"
$env:AWS_SECRET_ACCESS_KEY="your secret access key"
$env:AWS_DEFAULT_REGION="default region"

- terraform init : It will download required providers and dependencies

- terraform workspace new WorkspaceName : I have using Development, UAT and Production workspaces so for example to create Development Workspace your command would be : terraform workspace new Development

To select a workspace use : Terraform Select WorkspaceName

terraform plan -out xyz.tfplan : To save terraform file locally 

terraform apply xyz.tfplan : To provision the infrastructure 

terraform destroy

Thanks and happy automating!

Pinal
