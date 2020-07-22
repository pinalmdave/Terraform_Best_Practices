network_address_space = {
  Development = "10.0.0.0/16"
  UAT         = "10.1.0.0/16"
  Production  = "10.2.0.0/16"
}

instance_size = {
  Development = "t2.micro"
  UAT         = "t2.small"
  Production  = "t2.medium"
}

subnet_count = {
  Development = 1
  UAT         = 2
  Production  = 2
}

instance_count = {
  Development = 1
  UAT         = 2
  Production  = 3
}

