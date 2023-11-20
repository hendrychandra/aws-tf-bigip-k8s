


output "k8s-master-access-fqdn" {
  value = [for each in keys(var.k8s-master-public-network-interface-private-ips) : aws_route53_record.k8s-master-sub-domain[each].name]
}

output "k8s-worker-access-fqdn" {
  value = [for each in keys(var.k8s-worker-public-network-interface-private-ips) : aws_route53_record.k8s-worker-sub-domain[each].name]
}


