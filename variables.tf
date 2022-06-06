variable "aws_account_1_id" {
  type = string
}
variable "aws_profile_account_1" {
  type = string
}
variable "aws_region_account_1" {
  type = string
}
variable "aws_account_2_id" {
  type = string
}
variable "aws_profile_account_2" {
  type = string
}
variable "aws_region_account_2" {
  type = string
}
variable "aws_remote_state_id" {
  type = string
}
variable "aws_profile_remote_state" {
  type = string
}
variable "aws_region_remote_state" {
  type = string
}
variable "account_1_vpc_name" {
  type = string
}
variable "account_1_vpc_cidr" {
  type = string
}
variable "account_1_vpc_private_subnet_cidr" {
  type = string
}
variable "account_1_vpc_public_subnet_cidr" {
  type = string
}
variable "tags" {
  type = map(string)
  default = {
    terraform   = true
    environment = "dev"
    created-by  = "javier.bertoli"
  }
}
variable "account_1_ec2_instance_name" {
  type    = string
  default = "test-instance"
}
variable "account_1_ec2_instance_ami" {
  type    = string
  default = ""
}
variable "account_1_ec2_instance_type" {
  type    = string
  default = "t3.micro"
}
variable "account_1_ec2_instance_key_name" {
  type    = string
  default = ""
}
variable "account_1_ssm_session_logs_bucket_name" {
  type    = string
  default = "javier.bertoli-ssm-session-logs"
}
variable "account_1_ssm_access_logs_bucket_name" {
  type    = string
  default = "javier.bertoli-ssm-access-logs"
}
variable "account_2_bucket_name" {
  type    = string
  default = "javier.bertoli-account-2-bucket"
}
