output "identifier" {
  value = "${var.identifier}"
}


# SECURITY GROUP

output "security_group.id" {
  value = "${aws_security_group.sg.id}"
}

output "security_group.vpc_id" {
  value = "${aws_security_group.sg.vpc_id}"
}

output "security_group.owner_id" {
  value = "${aws_security_group.sg.owner_id}"
}

output "security_group.name" {
  value = "${aws_security_group.sg.name}"
}

output "security_group.description" {
  value = "${aws_security_group.sg.description}"
}

output "security_group.ingress" {
  value = "${aws_security_group.sg.ingress}"
}

output "security_group.egress" {
  value = "${aws_security_group.sg.egress}"
}


# SECURITY GROUP SSH RULE

// Bugs are produced trying to produce this when ssh access is off.
// @see https://github.com/hashicorp/terraform/issues/15300


# ELB

output "elb.id" {
  value = "${aws_elb.elb.id}"
}

output "elb.name" {
  value = "${aws_elb.elb.name}"
}

output "elb.dns_name" {
  value = "${aws_elb.elb.dns_name}"
}

output "elb.instances" {
  value = "${aws_elb.elb.instances}"
}

output "elb.instances.first" {
  value = "${aws_elb.elb.instances[0]}"
}

output "elb.instances.count" {
  value = "${length(aws_elb.elb.instances)}"
}

output "elb.source_security_group" {
  value = "${aws_elb.elb.source_security_group}"
}

output "elb.source_security_group_id" {
  value = "${aws_elb.elb.source_security_group_id}"
}
