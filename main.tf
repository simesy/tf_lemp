provider "aws" {
  region = "${var.aws_region}"
}

## Configures base VPC
module "vpc_base" {
  source = "github.com/unifio/terraform-aws-vpc?ref=master//base"

  enable_dns          = "false"
  enable_hostnames    = "false"
  stack_item_fullname = "${var.application_id}"
  stack_item_label    = "${var.identifier}"
  vpc_cidr            = "172.16.0.0/21"
}

## Configures VPC Availabilty Zones
module "vpc_az" {
  source = "github.com/unifio/terraform-aws-vpc?ref=master//az"

  azs_provisioned       = "3"
  enable_dmz_public_ips = "false"
  lans_per_az           = "1"
  nat_eips_enabled      = "0"
  rt_dmz_id             = "${module.vpc_base.rt_dmz_id}"
  stack_item_fullname   = "${var.application_id}"
  stack_item_label      = "${var.identifier}"
  vpc_id                = "${module.vpc_base.vpc_id}"
}


# Get the user_data script that will run on each nginx server.
# Used in aws_launch_configuration.
data "template_file" "user_data_nginx" {
  template =  "${file("${path.module}/nginx/user_data.tpl")}"
  vars {
    app_repo = "${var.app_repo}"
    app_playbook = "${var.app_playbook}"
  }
}

# SSH Key for remote access to nginx servers.
# Used in aws_launch_configuration.
resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.identifier}-ssh-key"
  public_key = "${var.public_key}"
}

# AWS Launch configuration for auto scaling group.
resource "aws_launch_configuration" "lc" {
  name          = "${var.identifier}-lc"
  image_id      = "${var.aws_ami}"
  instance_type = "${var.aws_size}"
  key_name      = "${var.identifier}-ssh-key"
  # Security group
  security_groups = ["${aws_security_group.sg.id}"]
  user_data       = "${data.template_file.user_data_nginx.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

# The security group allows HTTP in and everything out.
resource "aws_security_group" "sg" {
  name        = "${var.identifier}-web-sg"
  description = "Http and optionally SSH traffic."

  vpc_id = "${module.vpc_base.vpc_id}"

  # SSH access.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "Name" = "${var.identifier}-web-sg"
    "Application ID" = "${var.application_id}"
  }

}

# @todo Temporarily removed below - can be readded when https://github.com/hashicorp/terraform/issues/15300 is fixed?

# Attach an SSH access rule  to the security group if remote_access=true
#resource "aws_security_group_rule" "ssh_access" {
#  type            = "ingress"
#  from_port       = 22
#  to_port         = 22
#  protocol        = "tcp"
#  cidr_blocks     = ["0.0.0.0/0"]
#
#  security_group_id = "${aws_security_group.sg.id}"
#
  # This logic determines if 0 (disabled) or 1 (enabled) SSH inbound
  # rules are added to the security group.
#  count = 1
#  count = "${var.remote_access == "true" ? 1 : 0}"
#}

#
# Autoscaling Group and Load Balancer.
#


# AWS Autoscaling group
resource "aws_autoscaling_group" "asg" {
  availability_zones   = ["${split(",", var.aws_az)}"]
  name                 = "${var.identifier}-web-asg"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.lc.name}"
  load_balancers       = ["${aws_elb.elb.name}"]
  vpc_zone_identifier  = ["${module.vpc_az.dmz_ids}"]

  tag {
    key                 = "Name"
    value               = "${var.identifier}-web-asg"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Application ID"
    value               = "${var.application_id}"
    propagate_at_launch = "true"
  }

}


# AWS Load balancer
resource "aws_elb" "elb" {
  name = "${var.identifier}-web-elb"

  # The same availability zone as our instances
  availability_zones = ["${split(",", var.aws_az)}"]
  security_groups      = ["${aws_security_group.sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 15
  }

  tags {
    "Name" = "${var.identifier}-web-elb"
    "Application ID" = "${var.application_id}"
  }

}

