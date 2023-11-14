


output "k8s-ami" {
  value = data.aws_ami.k8s-ami
}

output "access-fqdn" {
  value = [for each in keys(var.aws-network-interface-k8s-master1-public-subnet-private-ips) : aws_route53_record.sub-domain[each].name]
}


