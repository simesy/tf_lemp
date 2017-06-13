output "tflemp_elb_name" {
  value = "${aws_elb.elb_prod.dns_name}"
}

output "tflemp_elb_ip" {
  value = "TODO"
}
