# Deployment Guide
Ensure AWS CLI and Terraform are installed on your machine.

### Setting up AWS Account
1. Open a terminal or command prompt on your console and navigate to the project directory
2. Run the command 'aws configure'
3. Enter your access key ID
4. Enter your secret access key ID
5. Enter the default region(e.g. eu-north-1)
6. Enter the default output format (e.g. json)

When the AWS configuration is done, deploy the infrastructure using the following steps:
1. To initialize Terraform, run __terraform init__,
2. Then generate a deployment plan to preview the changes terraform will make, run __terraform plan__,
3. Finally, __terraform apply__ to apply the changes.

After deployment, Terraform outputs a URL to the webpage in terminal