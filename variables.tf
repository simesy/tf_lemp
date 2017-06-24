variable "identifier" {
  description = "Used to label resources."
  default     = "somefin"
}

variable "bluegreen_id" {
  description = "Applied when parallel resources are created."
  default     = "blue"
}

variable "application_id" {
  description = "Applied as the Application ID for Resource Grouping."
  default     = "tflemp_app"
}

variable "app_repo" {
  description = "A full http path to a repository containing a webroot and a playbook."
  default     = "https://github.com/simesy/tf_lemp"
}

variable "app_checkout" {
  description = "A branch or tag on the repo."
  default     = "master"
}

variable "app_playbook" {
  description = "Path to the playbook file in the `app_repo` repository."
  default     = "webserver/playbook.yml"
}

variable "aws_region" {
  description = "The AWS region to create things in. Defaults to Sydney."
  default     = "ap-southeast-2"
}

variable "aws_az" {
  description = "Availability zones. Defaults to Sydney."
  default     = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
}


# @todo Replace AMI with pre-baked or vanilla Ubuntu. Currently uses https://aws.amazon.com/marketplace/pp/B01N0MCONW
# Hence references to "jet".
variable "aws_ami" {
  description = "AMI which is available in the aws_region. You should consider the default *insecure*."
  default     = "ami-ba231ad9"
}

# Auto scaling group settings.

variable "asg_min" {
  description = "Min number of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max number of servers in ASG"
  default     = "2"
}

variable "asg_desired" {
  description = "Desired number of servers in ASG"
  default     = "1"
}

variable "aws_size" {
  default     = "t2.micro"
  description = "AWS instance type"
}


//variable "rds_master_username" {
//  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
//}
//
//variable "rds_master_password" {
//  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
//}
//

variable "remote_access" {
  description = "Whether to allow remote (SSH) access to the EC instances in the load balancer."
  default     = "false"
}

variable "public_key" {
  description = "Public key which will be deployed to the web servers. The default public is not usable for security reasons."
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+ht5bqptAZuZevqSw6VWn/lLLT3nbQY+B11vnY5GouB2IriqgocErWsvAdGkUKhE4MSP53fKcH+WB9lUNQ2gxixtnT8qMr1xJ2pDxE5eaTMLyNxoTzySyH/leEzR34Eh/HIR/hRJqQwUrE5I5BbXje/TAGNPRcYKZC2TtOIKSY5Xsydtxw8Zp+l+VmweZvUYKEanUXxIlZnAOGYfWoHQn1fovJObkvuaG7glo7t3m6qgJqlT78kOnsMMy1RO3TxwDK1QlWjMy1SH4s84+cU1Gy8RHLDZ71F762wvLH3jzEp3OQbgTF3DBRz5nmL9M8+PV5xqmTdqvGXo8bY/RjGWcxa+eyP/p78cI8dMWB7rQxJ1pLuGSw+kg+OH9QOJRM84GkdfASfv6xpu3tXW5yqHd6sSgbaPdtA0BzXNicBjcDo4vOU1/B0cht4hXs82JdK2Nxixd3HKlCZDJ0D4+Nv4PdnQdmxw6A2zHgTjv99yRukk9SmBl4yXt/4p+vfyArcbtqegQbeX/7TGTA5KupqOEgT28Wjmg/dozYooZPSQhFY46e1ZHCZwuPg+XmrWlcgCKf386jTrG61x0Rqw/Jc9PUQ3pa7u7/exk4hG4MirEk6uAzo2Cj/5HRJ7bVIHpV7FBqIbGKggmvRXNp35jMWBjkioW6z4R5QMPUQqsI06IKw== default@example.com"
}

