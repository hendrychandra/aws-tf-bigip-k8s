


resource "aws_vpc" "vpc-terraform-test" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "vpc-terraform-test"
  }
}

resource "aws_internet_gateway" "internet_gateway-terraform-test" {
  vpc_id     = aws_vpc.vpc-terraform-test.id
  depends_on = [aws_vpc.vpc-terraform-test]
  tags = {
    Name = "internet_gateway-terraform-test"
  }
}



resource "aws_route_table" "public-route_table-terraform-test" {
  vpc_id     = aws_vpc.vpc-terraform-test.id
  depends_on = [aws_vpc.vpc-terraform-test, aws_internet_gateway.internet_gateway-terraform-test]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway-terraform-test.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.internet_gateway-terraform-test.id
  }
  tags = {
    Name = "public-route_table-terraform-test"
  }
}

resource "aws_subnet" "public-subnet-terraform-test" {
  vpc_id            = aws_vpc.vpc-terraform-test.id
  depends_on        = [aws_vpc.vpc-terraform-test]
  availability_zone = "ap-southeast-1a"
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "public-subnet-terraform-test"
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
    Name = "private-route_table-terraform-test"
  }
}

resource "aws_subnet" "private-subnet-terraform-test" {
  vpc_id            = aws_vpc.vpc-terraform-test.id
  depends_on        = [aws_vpc.vpc-terraform-test]
  availability_zone = "ap-southeast-1a"
  cidr_block        = "10.0.10.0/24"
  tags = {
    Name = "private-subnet-terraform-test"
  }
}

resource "aws_route_table_association" "private-route_table_association-terraform-test" {
  subnet_id      = aws_subnet.private-subnet-terraform-test.id
  route_table_id = aws_route_table.private-route_table-terraform-test.id
  depends_on     = [aws_vpc.vpc-terraform-test, aws_internet_gateway.internet_gateway-terraform-test, aws_subnet.private-subnet-terraform-test, aws_route_table.private-route_table-terraform-test]
}



resource "aws_security_group" "public-security_group-terraform-test" {
  name        = "public-security_group-terraform-test"
  description = "Allow TLS Inbound Traffic"
  vpc_id      = aws_vpc.vpc-terraform-test.id
  depends_on  = [aws_vpc.vpc-terraform-test]
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "K8s NodePorts"
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc-terraform-test.cidr_block, "127.0.0.0/24"]
    # ipv6_cidr_blocks = [aws_vpc.vpc-terraform-test.ipv6_cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "public-security_group-terraform-test"
  }
}

resource "aws_security_group" "private-security_group-terraform-test" {
  name        = "private-security_group-terraform-test"
  description = "Allow ALL"
  vpc_id      = aws_vpc.vpc-terraform-test.id
  depends_on  = [aws_vpc.vpc-terraform-test]
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "private-security_group-terraform-test"
  }
}



resource "aws_network_interface" "public-gw-network_interface-terraform-test" {
  subnet_id         = aws_subnet.public-subnet-terraform-test.id
  source_dest_check = false
  private_ips       = ["10.0.1.123"]
  security_groups   = [aws_security_group.public-security_group-terraform-test.id]
  depends_on        = [aws_vpc.vpc-terraform-test, aws_subnet.public-subnet-terraform-test, aws_security_group.public-security_group-terraform-test]
  tags = {
    Name = "public-gw-network_interface-terraform-test"
  }
}

resource "aws_network_interface" "private-gw-network_interface-terraform-test" {
  subnet_id         = aws_subnet.private-subnet-terraform-test.id
  source_dest_check = false
  private_ips       = ["10.0.10.123"]
  security_groups   = [aws_security_group.private-security_group-terraform-test.id]
  depends_on        = [aws_vpc.vpc-terraform-test, aws_subnet.private-subnet-terraform-test, aws_security_group.private-security_group-terraform-test]
  tags = {
    Name = "private-gw-network_interface-terraform-test"
  }
}

resource "aws_network_interface" "private-server-network_interface-terraform-test" {
  subnet_id         = aws_subnet.private-subnet-terraform-test.id
  source_dest_check = false
  private_ips       = ["10.0.10.222"]
  security_groups   = [aws_security_group.private-security_group-terraform-test.id]
  depends_on        = [aws_vpc.vpc-terraform-test, aws_subnet.private-subnet-terraform-test, aws_security_group.private-security_group-terraform-test]
  tags = {
    Name = "private-server-network_interface-terraform-test"
  }
}

resource "aws_eip" "public-gw-eip-terraform-test" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.public-gw-network_interface-terraform-test.id
  associate_with_private_ip = "10.0.1.123"
  depends_on                = [aws_vpc.vpc-terraform-test, aws_network_interface.public-gw-network_interface-terraform-test]
  tags = {
    Name = "public-gw-eip-terraform-test"
  }
}









resource "aws_instance" "gw-ubuntu-20-instance-terraform-test" {
  # ami               = "ami-084009f26f70a7c0b"
  # instance_type     = "m5.xlarge"
  ami               = data.aws_ami.ubuntu-20-ami-terraform-test.id
  instance_type     = "t3a.medium"
  depends_on        = [aws_vpc.vpc-terraform-test, aws_network_interface.public-gw-network_interface-terraform-test, aws_network_interface.private-gw-network_interface-terraform-test]
  availability_zone = "ap-southeast-1a"
  key_name          = "AWS_F5_Singapore_KeyPair"
  network_interface {
    network_interface_id = aws_network_interface.public-gw-network_interface-terraform-test.id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.private-gw-network_interface-terraform-test.id
    device_index         = 1
  }
  root_block_device {
    delete_on_termination = true
    volume_size           = 69
    tags = {
      Name = "root-volume-gw-ubuntu-20-instance-terraform-test"
    }
  }
  user_data = <<EOF
#!/bin/bash
cd /home/ubuntu;sudo curl -fksSLO --retry 333 https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/VMWrapSingleNodeClusterApplicationService.sh;sudo chmod 777 /home/ubuntu/VMWrapSingleNodeClusterApplicationService.sh;sudo chown $(id -u):$(id -g) /home/ubuntu/VMWrapSingleNodeClusterApplicationService.sh;runuser -l ubuntu -c '/home/ubuntu/VMWrapSingleNodeClusterApplicationService.sh'
EOF
  tags = {
    Name = "gw-ubuntu-20-instance-terraform-test"
  }
}


