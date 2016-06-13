variable "aws_region" {
  description = "AWS region to launch servers."
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
  default = {
    "us-west-2" = ""
  }
}

variable "availability_zones" {
  description = "Comma separated list of EC2 availability zones to launch instances, must be within region"
  default = {
    "us-west-2" = "us-west-2a,us-west-2b"
  }
}

variable "subnet_ids" {
  description = "Comma separated list of subnet ids, must match availability zones"
  default = {
    "us-west-2" = ""
  }
}

variable "security_group_ids" {
  description = "Comma separated list of security group ids"
  default = {
    "us-west-2" = ""
  }
}

variable "ecs_role" {
  description = "ecs role for connecting agent to elb"
  default = {
    "us-west-2" = ""
  }
}

variable "s3_bucket_name" {
  description = "s3 bucket for images"
  default = {
    "us-west-2" = "mah-s3-bucket-murica"
  }
}

variable "dns_zone" {
  default = {
    "us-west-2" = ""
  }
}

variable "dns_name" {
  default = {
    "us-west-2" = ""
  }
}