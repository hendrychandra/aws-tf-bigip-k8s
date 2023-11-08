


output "ubuntu-20-ami" {
  value = data.aws_ami.k8s-ami
}

output "fqdn" {
  value = aws_route53_record.sub-domain.name
}


