output "instance_id" {
  value = module.account_1_ec2_instance.id
}
output "bucket_name" {
  value = module.account_2_bucket.s3_bucket_bucket_domain_name
}
