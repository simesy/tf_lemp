# Specify the provider and access details

provider "aws" {
  region = "${var.aws_region}"
}

# User data script for webserver.
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

# SSH Key for remote access.
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh-access"
  public_key = "${var.remote_key}"
}

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
    "Application ID" = "${var.tag}"
  }

}

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
    value               = "${var.tag}"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "lc_prod" {
  image_id      = "${var.aws_ami}"
  instance_type = "${var.aws_size}"
  key_name      = "ssh-access"
  # Security group
  security_groups = ["${aws_security_group.sg_default.id}"]
  user_data       = "${template_file.user_data_nginx.rendered}"
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "sg_default" {
  name        = "${var.identifier}-web-sg"
  description = "Http and optionally SSH traffic."

  # HTTP access from anywhere.
  # @todo pin down to ELB only.
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
  //  "Name" = "${format("%s-web-sg", "${var.identifier}")}"
    "Name" = "${var.identifier}-web-sg"
    "Application ID" = "${var.tag}"
  }
}

resource "aws_security_group_rule" "sg_rule_allow_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.sg_default.id}"

  count = "${var.remote_access == "true" ? 1 : 0}"
}