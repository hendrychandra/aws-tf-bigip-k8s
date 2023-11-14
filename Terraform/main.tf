


resource "aws_vpc" "vpc-terraform-test" {
  cidr_block       = "${var.aws-vpc-cidr-prefix}.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = var.aws-vpc-tag-name
  }
}

resource "aws_internet_gateway" "internet_gateway-terraform-test" {
  vpc_id     = aws_vpc.vpc-terraform-test.id
  depends_on = [aws_vpc.vpc-terraform-test]
  tags = {
    Name = var.aws-internet-gateway-tag-name
  }
}



resource "aws_route_table" "public-route_table-terraform-test" {
  vpc_id     = aws_vpc.vpc-terraform-test.id
  depends_on = [aws_vpc.vpc-terraform-test, aws_internet_gateway.internet_gateway-terraform-test]
  route {
    cidr_block = var.aws-route-cidr-any-ipv4
    gateway_id = aws_internet_gateway.internet_gateway-terraform-test.id
  }
  route {
    ipv6_cidr_block = var.aws-route-cidr-any-ipv6
    gateway_id      = aws_internet_gateway.internet_gateway-terraform-test.id
  }
  tags = {
    Name = var.aws-public-route-table-tag-name
  }
}

resource "aws_subnet" "public-subnet-terraform-test" {
  vpc_id            = aws_vpc.vpc-terraform-test.id
  depends_on        = [aws_vpc.vpc-terraform-test]
  availability_zone = "${var.aws-region}${var.aws-availability-zone-suffix}"
  cidr_block        = "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.0/24"
  tags = {
    Name = var.aws-public-subnet-tag-name
  }
}

resource "aws_route_table_association" "public-route_table_association-terraform-test" {
  subnet_id      = aws_subnet.public-subnet-terraform-test.id
  route_table_id = aws_route_table.public-route_table-terraform-test.id
  depends_on     = [aws_vpc.vpc-terraform-test, aws_internet_gateway.internet_gateway-terraform-test, aws_subnet.public-subnet-terraform-test, aws_route_table.public-route_table-terraform-test]
}



resource "aws_route_table" "private-route_table-terraform-test" {
  vpc_id     = aws_vpc.vpc-terraform-test.id
  depends_on = [aws_vpc.vpc-terraform-test, aws_internet_gateway.internet_gateway-terraform-test]
  tags = {
    Name = var.aws-private-route-table-tag-name
  }
}

resource "aws_subnet" "private-subnet-terraform-test" {
  vpc_id            = aws_vpc.vpc-terraform-test.id
  depends_on        = [aws_vpc.vpc-terraform-test]
  availability_zone = "${var.aws-region}${var.aws-availability-zone-suffix}"
  cidr_block        = "${var.aws-vpc-cidr-prefix}.${var.aws-private-subnet-cidr-infix}.0/24"
  tags = {
    Name = var.aws-private-subnet-tag-name
  }
}

resource "aws_route_table_association" "private-route_table_association-terraform-test" {
  subnet_id      = aws_subnet.private-subnet-terraform-test.id
  route_table_id = aws_route_table.private-route_table-terraform-test.id
  depends_on     = [aws_vpc.vpc-terraform-test, aws_internet_gateway.internet_gateway-terraform-test, aws_subnet.private-subnet-terraform-test, aws_route_table.private-route_table-terraform-test]
}



resource "aws_security_group" "public-security-group-terraform-test" {
  name        = var.aws-public-security-group-name
  description = var.aws-public-security-group-description
  vpc_id      = aws_vpc.vpc-terraform-test.id
  depends_on  = [aws_vpc.vpc-terraform-test]
  dynamic "ingress" {
    for_each = var.aws-security-group-ingress-k8s
    content {
      description      = "${ingress.value.description} Port ${ingress.value.from_port} to ${ingress.value.to_port} from ${join(",", ingress.value.cidr_blocks)} or ${join(",", ingress.value.ipv6_cidr_blocks)} on protocol ${ingress.value.protocol}"
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      self             = ingress.value.self
    }
  }
  dynamic "egress" {
    for_each = var.aws-security-group-egress-any
    content {
      description      = "${egress.value.description} Port ${egress.value.from_port} to ${egress.value.to_port} from ${join(",", egress.value.cidr_blocks)} or ${join(",", egress.value.ipv6_cidr_blocks)} on protocol ${egress.value.protocol}"
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      self             = egress.value.self
    }
  }
  tags = {
    Name = var.aws-public-security-group-tag-name
  }
}

resource "aws_security_group" "private-security-group-terraform-test" {
  name        = var.aws-private-security-group-name
  description = var.aws-private-security-group-description
  vpc_id      = aws_vpc.vpc-terraform-test.id
  depends_on  = [aws_vpc.vpc-terraform-test]
  dynamic "ingress" {
    for_each = var.aws-security-group-ingress-any
    content {
      description      = "${ingress.value.description} Port ${ingress.value.from_port} to ${ingress.value.to_port} from ${join(",", ingress.value.cidr_blocks)} or ${join(",", ingress.value.ipv6_cidr_blocks)} on protocol ${ingress.value.protocol}"
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      self             = ingress.value.self
    }
  }
  dynamic "egress" {
    for_each = var.aws-security-group-egress-any
    content {
      description      = "${egress.value.description} Port ${egress.value.from_port} to ${egress.value.to_port} from ${join(",", egress.value.cidr_blocks)} or ${join(",", egress.value.ipv6_cidr_blocks)} on protocol ${egress.value.protocol}"
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
      self             = egress.value.self
    }
  }
  tags = {
    Name = var.aws-private-security-group-tag-name
  }
}



resource "aws_network_interface" "public-gw-network-interface-terraform-test" {
  subnet_id         = aws_subnet.public-subnet-terraform-test.id
  source_dest_check = var.aws-network-interface-k8s-master1-public-subnet-source-dest-check
  private_ips       = [for ip-address-segment in var.aws-network-interface-k8s-master1-public-subnet-private-ips : "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.${ip-address-segment}"]
  security_groups   = [aws_security_group.public-security-group-terraform-test.id]
  depends_on        = [aws_vpc.vpc-terraform-test, aws_subnet.public-subnet-terraform-test, aws_security_group.public-security-group-terraform-test]
  tags = {
    Name = var.aws-network-interface-k8s-master1-public-subnet-tag-name
  }
}

resource "aws_network_interface" "private-gw-network-interface-terraform-test" {
  subnet_id         = aws_subnet.private-subnet-terraform-test.id
  source_dest_check = var.aws-network-interface-k8s-master1-private-subnet-source-dest-check
  private_ips       = [for ip-address-segment in var.aws-network-interface-k8s-master1-private-subnet-private-ips : "${var.aws-vpc-cidr-prefix}.${var.aws-private-subnet-cidr-infix}.${ip-address-segment}"]
  security_groups   = [aws_security_group.private-security-group-terraform-test.id]
  depends_on        = [aws_vpc.vpc-terraform-test, aws_subnet.private-subnet-terraform-test, aws_security_group.private-security-group-terraform-test]
  tags = {
    Name = var.aws-network-interface-k8s-master1-private-subnet-tag-name
  }
}

resource "aws_network_interface" "private-server-network-interface-terraform-test" {
  subnet_id         = aws_subnet.private-subnet-terraform-test.id
  source_dest_check = var.aws-network-interface-server1-private-subnet-source-dest-check
  private_ips       = [for ip-address-segment in var.aws-network-interface-server1-private-subnet-private-ips : "${var.aws-vpc-cidr-prefix}.${var.aws-private-subnet-cidr-infix}.${ip-address-segment}"]
  security_groups   = [aws_security_group.private-security-group-terraform-test.id]
  depends_on        = [aws_vpc.vpc-terraform-test, aws_subnet.private-subnet-terraform-test, aws_security_group.private-security-group-terraform-test]
  tags = {
    Name = var.aws-network-interface-server1-private-subnet-tag-name
  }
}

resource "aws_eip" "public-gw-eip-terraform-test" {
  for_each                  = toset([for ip-address-segment in var.aws-network-interface-k8s-master1-public-subnet-private-ips : tostring(ip-address-segment)])
  domain                    = "vpc"
  network_interface         = aws_network_interface.public-gw-network-interface-terraform-test.id
  associate_with_private_ip = "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.${each.value}"
  depends_on                = [aws_vpc.vpc-terraform-test, aws_network_interface.public-gw-network-interface-terraform-test]
  tags = {
    Name = var.aws-eip-k8s-master1-public-subnet-tag-name
  }
}









resource "aws_instance" "gw-ubuntu-20-instance-terraform-test" {
  ami               = data.aws_ami.k8s-ami.id
  instance_type     = var.k8s-master1-instance-type
  depends_on        = [aws_vpc.vpc-terraform-test, aws_network_interface.public-gw-network-interface-terraform-test, aws_network_interface.private-gw-network-interface-terraform-test]
  availability_zone = "${var.aws-region}${var.aws-availability-zone-suffix}"
  key_name          = var.aws-ec2-keypair-name
  network_interface {
    network_interface_id = aws_network_interface.public-gw-network-interface-terraform-test.id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.private-gw-network-interface-terraform-test.id
    device_index         = 1
  }
  root_block_device {
    delete_on_termination = var.k8s-master1-instance-root-block-device-delete-on-termination
    volume_size           = var.k8s-master1-instance-root-block-device-volume-size
    tags = {
      Name = var.k8s-master1-instance-root-block-device-tag-name
    }
  }
  user_data = <<EOF
#!/bin/bash
cd /home/ubuntu;sudo curl -fksSLO --retry 333 https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/VMWrapSingleNodeClusterApplicationService.sh;sudo chmod 777 /home/ubuntu/VMWrapSingleNodeClusterApplicationService.sh;sudo chown $(id -u):$(id -g) /home/ubuntu/VMWrapSingleNodeClusterApplicationService.sh;runuser -l ubuntu -c '/home/ubuntu/VMWrapSingleNodeClusterApplicationService.sh'
EOF
  tags = {
    Name = var.k8s-master1-instance-tag-name
  }
}









resource "aws_route53_record" "sub-domain" {
  for_each   = var.aws-network-interface-k8s-master1-public-subnet-private-ips
  depends_on = [aws_instance.gw-ubuntu-20-instance-terraform-test]
  zone_id    = data.aws_route53_zone.parent-domain.zone_id
  name       = "${each.key}.${data.aws_route53_zone.parent-domain.name}"
  type       = var.subdomain-record-type
  ttl        = var.subdomain-record-ttl
  records    = [aws_eip.public-gw-eip-terraform-test[each.value].public_ip]
}


