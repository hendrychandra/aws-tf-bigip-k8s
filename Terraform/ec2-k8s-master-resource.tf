


resource "aws_security_group" "tf-k8s-master-public-security-group" {
  name        = var.k8s-master-public-security-group-name
  description = var.k8s-master-public-security-group-description
  vpc_id      = aws_vpc.tf-vpc.id
  depends_on  = [aws_vpc.tf-vpc]
  dynamic "ingress" {
    for_each = var.k8s-master-public-security-group-ingress
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
    Name = var.k8s-master-public-security-group-tag-name
  }
}

resource "aws_security_group" "tf-k8s-master-private-security-group" {
  name        = var.k8s-master-private-security-group-name
  description = var.k8s-master-private-security-group-description
  vpc_id      = aws_vpc.tf-vpc.id
  depends_on  = [aws_vpc.tf-vpc]
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
    Name = var.k8s-master-private-security-group-tag-name
  }
}



resource "aws_network_interface" "tf-k8s-master-public-network-interface" {
  subnet_id         = aws_subnet.tf-public-subnet.id
  source_dest_check = var.k8s-master-public-network-interface-source-dest-check
  private_ips       = [for ip-address-segment in var.k8s-master-public-network-interface-private-ips : "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.${ip-address-segment}"]
  security_groups   = [aws_security_group.tf-k8s-master-public-security-group.id]
  depends_on        = [aws_vpc.tf-vpc, aws_subnet.tf-public-subnet, aws_security_group.tf-k8s-master-public-security-group]
  tags = {
    Name = var.k8s-master-public-network-interface-tag-name
  }
}

resource "aws_network_interface" "tf-k8s-master-private-network-interface" {
  subnet_id         = aws_subnet.tf-private-subnet.id
  source_dest_check = var.k8s-master-private-network-interface-source-dest-check
  private_ips       = [for ip-address-segment in var.k8s-master-private-network-interface-private-ips : "${var.aws-vpc-cidr-prefix}.${var.aws-private-subnet-cidr-infix}.${ip-address-segment}"]
  security_groups   = [aws_security_group.tf-k8s-master-private-security-group.id]
  depends_on        = [aws_vpc.tf-vpc, aws_subnet.tf-private-subnet, aws_security_group.tf-k8s-master-private-security-group]
  tags = {
    Name = var.k8s-master-private-network-interface-tag-name
  }
}



resource "aws_eip" "tf-k8s-master-public-eip" {
  for_each                  = toset([for ip-address-segment in var.k8s-master-public-network-interface-private-ips : tostring(ip-address-segment)])
  domain                    = "vpc"
  network_interface         = aws_network_interface.tf-k8s-master-public-network-interface.id
  associate_with_private_ip = "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.${each.value}"
  depends_on                = [aws_vpc.tf-vpc, aws_network_interface.tf-k8s-master-public-network-interface]
  tags = {
    Name = var.k8s-master-public-eip-tag-name
  }
}









resource "aws_instance" "tf-k8s-master-instance" {
  ami               = data.aws_ami.k8s-ami.id
  instance_type     = var.k8s-master-instance-type
  depends_on        = [aws_vpc.tf-vpc, aws_network_interface.tf-k8s-master-public-network-interface, aws_network_interface.tf-k8s-master-private-network-interface]
  availability_zone = "${var.aws-region}${var.aws-availability-zone-suffix}"
  key_name          = var.aws-ec2-keypair-name
  network_interface {
    network_interface_id = aws_network_interface.tf-k8s-master-public-network-interface.id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.tf-k8s-master-private-network-interface.id
    device_index         = 1
  }
  root_block_device {
    delete_on_termination = var.k8s-master-instance-root-block-device-delete-on-termination
    volume_size           = var.k8s-master-instance-root-block-device-volume-size
    tags = {
      Name = var.k8s-master-instance-root-block-device-tag-name
    }
  }
  user_data = <<EOF
#!/bin/bash
cd /home/ubuntu;sudo curl -fksSLO --retry 333 https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/VMWrapMaster.sh;sudo chmod 777 /home/ubuntu/VMWrapMaster.sh;sudo chown $(id -u):$(id -g) /home/ubuntu/VMWrapMaster.sh;runuser -l ubuntu -c '/home/ubuntu/VMWrapMaster.sh ${[for ip-address-segment in var.k8s-master-public-network-interface-private-ips : ${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.tostring(ip-address-segment)] [for ip-address-segment in var.k8s-worker-public-network-interface-private-ips : ${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.tostring(ip-address-segment)]}'
EOF
  tags = {
    Name = var.k8s-master-instance-tag-name
  }
}


