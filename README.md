Javier Bertoli terraform coding test
====================================

This repository contains the code to:

* Deploy a VPC in one account (ACCOUNT 1) with a private subnet
* Deploy an instance in the private subnet created above
* Enable and configure SSM in the VPC
* Configure SSM in the instance, so it can be accessed through it
* Create a S3 bucket in a second account (ACCOUNT 2) in another region
* Allow the instance to write to the bucket

Usage
-----

1. Clone the repo (unless you already did it)
2. Modify the variables in the file `terraform.tfvars` to suite your
   needs. Some other parameters are configurable. Check the `variables`
   file to find them, along with their default values.
3. The exam requested the `terraform.tfstate` to be stored in a S3 bucket.
   The configuration is done in the `backend.tf` file using the variables
   set in the `terraform.tfvars` file.
   The remote bucket and dynamo db table are *NOT* set with this code,
   you need to do it by yourself following
   [these guidelines](https://www.terraform.io/language/settings/backends/s3).
   [Here](https://www.golinuxcloud.com/configure-s3-bucket-as-terraform-backend/)
   you can find step-by-step instructions on configuring the required resources.
4. Once you have all the above set up, you can deploy with
   ```
   terraform init
   terraform apply
   ```
5. Once terraform finishes, you should be able to connect to your instance using
   `session manager`
   ```
   aws ssm start-session \
     --profile <account1_profile> \
     --target <instance_id>
   ```
