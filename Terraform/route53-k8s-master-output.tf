


output "access-fqdn" {
  value = [for each in keys(var.k8s-master-public-network-interface-private-ips) : aws_route53_record.sub-domain[each].name]
}


