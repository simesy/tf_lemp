#
# Define a Load Balancer and Autoscaling group of nginx servers.
#

provider "aws" {
  region = "${var.aws_region}"
}


#
# Prepping launch configuration, ssh keys and security groups.
#

# Get the user_data script that will run on each nginx server.
# Used in aws_launch_configuration.
resource "template_file" "user_data_nginx" {
  template =  "${file("${path.module}/nginx/user_data.tpl")}"
  vars {
    app_repo = "${var.app_repo}"
    app_playbook = "${var.app_playbook}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# SSH Key for remote access to nginx servers.
# Used in aws_launch_configuration.
resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.identifier}-ssh-key"
  public_key = "${var.remote_key}"
}

# AWS Launch configuration for auto scaling group.
resource "aws_launch_configuration" "lc_prod" {
  image_id      = "${var.aws_ami}"
  instance_type = "${var.aws_size}"
  key_name      = "${var.identifier}-ssh-key"
  # Security group
  security_groups = ["${aws_security_group.sg_default.id}"]
  user_data       = "${template_file.user_data_nginx.rendered}"
}

# The security group allows HTTP in and everything out.
resource "aws_security_group" "sg_default" {
  name        = "${var.identifier}-web-sg"
  description = "Http and optionally SSH traffic."

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

# Attach an SSH access rule  to the security group if remote_access=true
resource "aws_security_group_rule" "ssh_access" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.sg_default.id}"

  # This logic determines if 0 (disabled) or 1 (enabled) SSH inbound
  # rules are added to the security group.
  count = "${var.remote_access == "true" ? 1 : 0}"
}


#
# Autoscaling Group and Load Balancer.
#

# AWS Autoscaling group
resource "aws_autoscaling_group" "asg_prod" {
  availability_zones   = ["${split(",", var.aws_az)}"]
  name                 = "${var.identifier}-web-asg"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.lc_prod.name}"
  load_balancers       = ["${aws_elb.elb_prod.name}"]

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
resource "aws_elb" "elb_prod" {
  name = "${var.identifier}-web-elb"

  # The same availability zone as our instances
  availability_zones = ["${split(",", var.aws_az)}"]
  security_groups      = ["${aws_security_group.sg_default.id}"]

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
