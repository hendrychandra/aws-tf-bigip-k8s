


resource "aws_route53_record" "k8s-master-sub-domain" {
  for_each   = var.k8s-master-public-network-interface-private-ips
  depends_on = [aws_instance.tf-k8s-master-instance]
  zone_id    = data.aws_route53_zone.parent-domain.zone_id
  name       = "${each.key}.${data.aws_route53_zone.parent-domain.name}"
  type       = var.subdomain-record-type
  ttl        = var.subdomain-record-ttl
  records    = [aws_eip.tf-k8s-master-public-eip[each.value].public_ip]
}

resource "aws_route53_record" "k8s-worker-sub-domain" {
  for_each   = var.k8s-worker-public-network-interface-private-ips
  depends_on = [aws_instance.tf-k8s-worker-instance]
  zone_id    = data.aws_route53_zone.parent-domain.zone_id
  name       = "${each.key}.${data.aws_route53_zone.parent-domain.name}"
  type       = var.subdomain-record-type
  ttl        = var.subdomain-record-ttl
  records    = [aws_eip.tf-k8s-worker-public-eip[each.value].public_ip]
}


