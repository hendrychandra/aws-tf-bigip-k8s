


resource "aws_vpc" "tf-vpc" {
  cidr_block       = "${var.aws-vpc-cidr-prefix}.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = var.aws-vpc-tag-name
  }
}

resource "aws_internet_gateway" "tf-internet-gateway" {
  vpc_id     = aws_vpc.tf-vpc.id
  depends_on = [aws_vpc.tf-vpc]
  tags = {
    Name = var.aws-internet-gateway-tag-name
  }
}



resource "aws_route_table" "tf-public-route-table" {
  vpc_id     = aws_vpc.tf-vpc.id
  depends_on = [aws_vpc.tf-vpc, aws_internet_gateway.tf-internet-gateway]
  route {
    cidr_block = var.aws-route-cidr-any-ipv4
    gateway_id = aws_internet_gateway.tf-internet-gateway.id
  }
  route {
    ipv6_cidr_block = var.aws-route-cidr-any-ipv6
    gateway_id      = aws_internet_gateway.tf-internet-gateway.id
  }
  tags = {
    Name = var.aws-public-route-table-tag-name
  }
}

resource "aws_subnet" "tf-public-subnet" {
  vpc_id            = aws_vpc.tf-vpc.id
  depends_on        = [aws_vpc.tf-vpc]
  availability_zone = "${var.aws-region}${var.aws-availability-zone-suffix}"
  cidr_block        = "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.0/24"
  tags = {
    Name = var.aws-public-subnet-tag-name
  }
}

resource "aws_route_table_association" "tf-public-route-table-association" {
  subnet_id      = aws_subnet.tf-public-subnet.id
  route_table_id = aws_route_table.tf-public-route-table.id
  depends_on     = [aws_vpc.tf-vpc, aws_internet_gateway.tf-internet-gateway, aws_subnet.tf-public-subnet, aws_route_table.tf-public-route-table]
}



resource "aws_route_table" "tf-private-route-table" {
  vpc_id     = aws_vpc.tf-vpc.id
  depends_on = [aws_vpc.tf-vpc, aws_internet_gateway.tf-internet-gateway]
  tags = {
    Name = var.aws-private-route-table-tag-name
  }
}

resource "aws_subnet" "tf-private-subnet" {
  vpc_id            = aws_vpc.tf-vpc.id
  depends_on        = [aws_vpc.tf-vpc]
  availability_zone = "${var.aws-region}${var.aws-availability-zone-suffix}"
  cidr_block        = "${var.aws-vpc-cidr-prefix}.${var.aws-private-subnet-cidr-infix}.0/24"
  tags = {
    Name = var.aws-private-subnet-tag-name
  }
}

resource "aws_route_table_association" "tf-private-route-table-association" {
  subnet_id      = aws_subnet.tf-private-subnet.id
  route_table_id = aws_route_table.tf-private-route-table.id
  depends_on     = [aws_vpc.tf-vpc, aws_internet_gateway.tf-internet-gateway, aws_subnet.tf-private-subnet, aws_route_table.tf-private-route-table]
}









resource "aws_network_acl" "tf-public-network-acl" {
  vpc_id     = aws_vpc.tf-vpc.id
  subnet_ids = [aws_subnet.tf-public-subnet.id]
  dynamic "ingress" {
    for_each = var.aws-public-network-acl-xgress-cidr-block
    content {
      rule_no    = var.aws-network-acl-xgress.rule_no + ingress.key
      action     = var.aws-network-acl-xgress.action
      cidr_block = ingress.value
      protocol   = var.aws-network-acl-xgress.protocol
      from_port  = var.aws-network-acl-xgress.from_port
      to_port    = var.aws-network-acl-xgress.to_port
    }
  }
  dynamic "ingress" {
    for_each = var.aws-public-network-acl-xgress-ipv6-cidr-block
    content {
      rule_no         = var.aws-network-acl-xgress.rule_no + ingress.key + var.aws-network-acl-xgress-rule-no-ipv6-offset
      action          = var.aws-network-acl-xgress.action
      ipv6_cidr_block = ingress.value
      protocol        = var.aws-network-acl-xgress.protocol
      from_port       = var.aws-network-acl-xgress.from_port
      to_port         = var.aws-network-acl-xgress.to_port
    }
  }
  dynamic "egress" {
    for_each = var.aws-public-network-acl-xgress-cidr-block
    content {
      rule_no    = var.aws-network-acl-xgress.rule_no + egress.key
      action     = var.aws-network-acl-xgress.action
      cidr_block = egress.value
      protocol   = var.aws-network-acl-xgress.protocol
      from_port  = var.aws-network-acl-xgress.from_port
      to_port    = var.aws-network-acl-xgress.to_port
    }
  }
  dynamic "egress" {
    for_each = var.aws-public-network-acl-xgress-ipv6-cidr-block
    content {
      rule_no         = var.aws-network-acl-xgress.rule_no + egress.key + var.aws-network-acl-xgress-rule-no-ipv6-offset
      action          = var.aws-network-acl-xgress.action
      ipv6_cidr_block = egress.value
      protocol        = var.aws-network-acl-xgress.protocol
      from_port       = var.aws-network-acl-xgress.from_port
      to_port         = var.aws-network-acl-xgress.to_port
    }
  }
  tags = {
    Name = var.aws-public-network-acl-tag-name
  }
}


