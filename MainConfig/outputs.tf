##################################################################################
# OUTPUT
##################################################################################

output "ec2_public_ip" {
  value = {
    for instance in aws_instance.webserver :
    instance.id => instance.public_ip
  }
}

output "s3_bucket_name" {
  value = local.s3_bucket_name
}