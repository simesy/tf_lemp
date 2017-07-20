output "identifier" {
  value = "${var.identifier}"
}

output user_data_nginx {
  value = "${data.template_file.user_data_nginx.rendered}"
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


# LAUNCH CONFIGURATION

output "lc.id" {
  value = "${aws_launch_configuration.lc.id}"
}

output "lc.name" {
  value = "${aws_launch_configuration.lc.name}"
}


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

# Output something like this, or script it.
# Get the public addess with AWS CLI.
# aws ec2 describe-instances --instance-ids INSTANCE --query 'Reservations[].Instances[].PublicDnsName' --output text
# ssh -i ./tests/spec/insecure_key admin@OUTPUT-OF-ABOVE

output "elb.instances.count" {
  value = "${length(aws_elb.elb.instances)}"
}

output "elb.source_security_group" {
  value = "${aws_elb.elb.source_security_group}"
}

output "elb.source_security_group_id" {
  value = "${aws_elb.elb.source_security_group_id}"
}


# VPC

output vpc.id {
  value = "${module.vpc_base.vpc_id}"
}


# Route table.
output rt.route_table_id {
  value = "${module.vpc_base.rt_dmz_id}"
}

# Subnet IDs.
output vpc_az.dmz_ids {
  value = "${module.vpc_az.dmz_ids}"
}

# Internet gateway.
output igw.id {
  value = "${module.vpc_base.igw_id}"
}


# EFS

output efs_mnt.id {
  value = "${aws_efs_mount_target.efs_mnt.id}"
}

output efs_mnt.dns_name {
  value = "${aws_efs_mount_target.efs_mnt.dns_name}"
}

output efs_mnt.network_interface_id  {
  value = "${aws_efs_mount_target.efs_mnt.network_interface_id}"
}


# RDS

output rds.endpoint {
  value = "${aws_db_instance.rds.endpoint}"
}

output rds.address {
  value = "${aws_db_instance.rds.address}"
}

output rds.id {
  value = "${aws_db_instance.rds.id}"
}

output rds.name {
  value = "${aws_db_instance.rds.name}"
}


# Database subnet group.

output db_sng.id {
  value = "${aws_db_subnet_group.db_sng.id}"
}
