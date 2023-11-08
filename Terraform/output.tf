


output "ubuntu-20-ami" {
  value = data.aws_ami.ubuntu-20-ami-terraform-test
}

output "fqdn" {
  value = aws_route53_record.sub-domain.name
}


