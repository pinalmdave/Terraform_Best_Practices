##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {

}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "avzs" {}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

##################################################################################
# RESOURCES
##################################################################################

#Random ID
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

#-------------------------------------------Networking-------------------------------------------------------------#
resource "aws_vpc" "vpc" {
  cidr_block = var.network_address_space[terraform.workspace]
  tags       = merge(local.common_tags, { Name = "${local.env_name}-vpc" })
}

resource "aws_subnet" "subnet" {
  count                   = var.subnet_count[terraform.workspace]
  cidr_block              = cidrsubnet(var.network_address_space[terraform.workspace], 8, count.index)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.avzs.names[count.index]
  tags                    = merge(local.common_tags, { Name = "${local.env_name}-subnet${count.index + 1}" })

}

#----------------------------------------------EC2 INSTANCE---------------------------------------------------#

resource "aws_instance" "webserver" {
  count                  = var.instance_count[terraform.workspace]
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = var.instance_size[terraform.workspace]
  subnet_id              = aws_subnet.subnet[count.index % var.subnet_count[terraform.workspace]].id
  vpc_security_group_ids = [aws_security_group.webdmz-sg.id]
  key_name               = var.key_name
  iam_instance_profile   = module.bucket.instance_profile.name
  depends_on             = [module.bucket]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  tags = merge(local.common_tags, { Name = "${local.env_name}-webserver${count.index + 1}" })

}

#----------------------------------------------S3-------------------------------------------------------------#

module "bucket" {
  name        = local.s3_bucket_name
  source      = ".\\Modules\\s3"
  common_tags = local.common_tags
}

#----------------------------------------------SECURITY GROUP-------------------------------------------------#
resource "aws_security_group" "webdmz-sg" {
  name   = "webdmz-sg"
  vpc_id = aws_vpc.vpc.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.network_address_space[terraform.workspace]]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "${local.env_name}-webdmz-sg" })
}




