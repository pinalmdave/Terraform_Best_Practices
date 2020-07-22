##################################################################################
# VARIABLES
##################################################################################

variable network_address_space {
  type = map(string)
}

variable "instance_size" {
  type = map(string)
}

variable "subnet_count" {
  type = map(number)
}

variable "instance_count" {
  type = map(number)
}

variable "bucket_name_prefix" {
  type    = string
  default = "tf-remote-state-bucket"
}

variable "key_name" {
  type    = string
  default = "keypair-us-east-1"
}

variable "private_key_path" {
type    = string
default = "C:\\keypair-us-east-1.pem"
}

##################################################################################
# LOCALS
##################################################################################

locals {
  env_name = lower(terraform.workspace)

  common_tags = {
    Environment = local.env_name
  }
  s3_bucket_name = "${var.bucket_name_prefix}-${local.env_name}-${random_integer.rand.result}"
}