output "identifier" {
  value = "${var.identifier}"
}


# SECURITY GROUP

output "security_group.id" {
  value = "${aws_security_group.sg_default.id}"
}

output "security_group.vpc_id" {
  value = "${aws_security_group.sg_default.vpc_id}"
}

output "security_group.owner_id" {
  value = "${aws_security_group.sg_default.owner_id}"
}

output "security_group.name" {
  value = "${aws_security_group.sg_default.name}"
}

output "security_group.description" {
  value = "${aws_security_group.sg_default.description}"
}

output "security_group.ingress" {
  value = "${aws_security_group.sg_default.ingress}"
}

output "security_group.egress" {
  value = "${aws_security_group.sg_default.egress}"
}


# SECURITY GROUP SSH RULE

// Bugs are produced trying to produce this when ssh access is off.
// @see https://github.com/hashicorp/terraform/issues/15300


# ELB

output "elb.id" {
  value = "${aws_elb.elb_prod.id}"
}

output "elb.name" {
  value = "${aws_elb.elb_prod.name}"
}

output "elb.dns_name" {
  value = "${aws_elb.elb_prod.dns_name}"
}

output "elb.instances" {
  value = "${aws_elb.elb_prod.instances}"
}

output "elb.instances.first" {
  value = "${aws_elb.elb_prod.instances[0]}"
}

output "elb.instances.count" {
  value = "${length(aws_elb.elb_prod.instances)}"
}

output "elb.source_security_group" {
  value = "${aws_elb.elb_prod.source_security_group}"
}

output "elb.source_security_group_id" {
  value = "${aws_elb.elb_prod.source_security_group_id}"
}
