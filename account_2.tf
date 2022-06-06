# Create bucket in account 2
module "account_2_bucket" {
  providers = {
    aws = aws.account2
  }
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = var.account_2_bucket_name
  acl           = "private"
  attach_policy = true
  policy        = data.aws_iam_policy_document.account_2_bucket_allow_account_1_ec2_instance.json
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning = {
    enabled = true
  }
  tags = var.tags
}
# Access bucket policy
data "aws_iam_policy_document" "account_2_bucket_allow_account_1_ec2_instance" {
  provider = aws.account2
  statement {
    sid    = "ObjectPolicy"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.aws_account_1_id}:root",
      ]
    }
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:DeleteObjectVersion",
      "s3:DeleteObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      "${module.account_2_bucket.s3_bucket_arn}/*"
    ]
  }
  statement {
    sid    = "BucketPolicy"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.aws_account_1_id}:root",
      ]
    }
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      module.account_2_bucket.s3_bucket_arn
    ]
  }
}
