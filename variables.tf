
variable "identifier" {
  description = "Used to label resources."
  default     = "tflemp"
}

variable "application_id" {
  description = "Applied as the Application ID for Resource Grouping."
  default     = "tflemp_app"
}

variable "app_repo" {
  description = "A full http path to a repository containing a webroot and a playbook."
  default     = "https://github.com/simesy/tf_lemp"
}

variable "app_playbook" {
  description = "Path to the playbook file in the `app_repo` repository."
  default     = "nginx/playbook.yml"
}

variable "remote_access" {
  description = "Whether to allow remote (SSH) access to the EC instances in the load balancer."
  default     = "false"
}

variable "remote_key" {
  description = "Public key which will be deployed to the nginx servers."
  default     = "CHANGEME"
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
