# Create VPC with 1 private subnet
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_image" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "account_1_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = var.account_1_vpc_name
  cidr   = var.account_1_vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true
  azs = [
    data.aws_availability_zones.available.names[0]
  ]
  private_subnets = [
    var.account_1_vpc_private_subnet_cidr
  ]
  public_subnets = [
    var.account_1_vpc_public_subnet_cidr
  ]
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false
  tags               = var.tags
}

resource "aws_security_group" "vpc_tls" {
  name_prefix = "${var.account_1_vpc_name}-vpc_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.account_1_vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.account_1_vpc_cidr]
  }

  tags = var.tags
}
module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  vpc_id = module.account_1_vpc.vpc_id
  security_group_ids = [
    module.account_1_vpc.default_security_group_id,
    aws_security_group.vpc_tls.id
  ]
  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.account_1_vpc.private_subnets
      security_group_ids = [
        module.account_1_vpc.default_security_group_id,
        aws_security_group.vpc_tls.id
      ]
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.account_1_vpc.private_subnets
      security_group_ids = [
        module.account_1_vpc.default_security_group_id,
        aws_security_group.vpc_tls.id
      ]
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = module.account_1_vpc.private_subnets
      security_group_ids = [
        module.account_1_vpc.default_security_group_id,
        aws_security_group.vpc_tls.id
      ]
    },
    kms = {
      service             = "kms"
      private_dns_enabled = true
      subnet_ids          = module.account_1_vpc.private_subnets
      security_group_ids = [
        module.account_1_vpc.default_security_group_id,
        aws_security_group.vpc_tls.id
      ]
    },
  }
}

# Create instance in the private subnet, with an attached IAM profile
# to access the bucket in account_2
module "account_1_ec2_instance" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.30.0"
  enabled = true

  name          = var.account_1_ec2_instance_name
  ami           = var.account_1_ec2_instance_ami == "" ? data.aws_ami.amazon_image.id : var.account_1_ec2_instance_ami
  instance_type = var.account_1_ec2_instance_type
  subnets       = [module.account_1_vpc.private_subnets[0]]
  key_name      = var.account_1_ec2_instance_key_name
  vpc_id        = module.account_1_vpc.vpc_id
  ssm_enabled   = true
  monitoring    = false

  tags = var.tags
}

# Access bucket IAM policy document
data "aws_iam_policy_document" "account_1_ec2_instance_access_bucket_in_account_2" {
  statement {
    sid    = "AccessBucketAccount2"
    effect = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      module.account_2_bucket.s3_bucket_arn
    ]
  }
}
# Access bucket IAM policy
resource "aws_iam_policy" "account_1_ec2_instance_access_bucket_in_account_2" {
  name   = "access_bucket_in_account_2"
  policy = data.aws_iam_policy_document.account_1_ec2_instance_access_bucket_in_account_2.json
}
# Attach policy to role
resource "aws_iam_role_policy_attachment" "account_1_ec2_instance_access_bucket_in_account_2" {
  role       = module.account_1_ec2_instance.role
  policy_arn = aws_iam_policy.account_1_ec2_instance_access_bucket_in_account_2.arn
}
