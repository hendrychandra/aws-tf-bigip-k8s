


# One real example: mistake in assigning IP Address and/or IP Subnet,
# happen quite often. This activity is also meticulous activity which
# needs higher than average attentions.
# Therefore it is best if the script can help by adopting principle of
# "Don't Repeat Yourself" (DRY).
# For example: the whole VPC will have the same Prefix
# (largest is /16). Therefore all Subnets and IP Addresses in the same
# VPC will have the same prefix. By NOT requiring user to re-type the
# Prefix, there are LESS chances of error.
#
# Since Terraform's variable canNOT be formulated from one or more
# other variable(s), this condition pushes variable's declaration
# below to as small-granularity as possible.
#
# Example: List or Map data-type contain large chunk of data at once.
# Unless there are no possibilities/needs to:
# (*) make data dynamically composed from other variable(s)
# (*) consolidate some of the data which have similar pattern(s)
# Then use a more native data-type such as string or number.
#
# Example: Tags can be declared as map(string).
# But then you need to keep repeating object's name-tag with the same
# prefix (like project name, or owner, etc. for administrative
# purposes).
# Worse if you need to keep specific tag for every object, like
# owner-tag; since then every object will have the exact same static
# owner-tag, which you need to keep repeating in the variable
# declaration.



##########################
# Access and Credentials #
##########################

variable "aws-cli-profile" {
  description = "AWS CLI Profile"
  type        = string
}

variable "aws-ec2-keypair-name" {
  description = "AWS EC2 KeyPair"
  type        = string
}



###############
# AWS Route53 #
###############

variable "existing-aws-route53-zone" {
  description = "Existing AWS Route53 DNS Zone"
  type        = string
}

variable "subdomain-record-name" {
  description = "Subdomain Record Name of the AWS Route53 DNS Zone"
  type        = string
  default     = "demo"
}

variable "subdomain-record-type" {
  description = "Subdomain Record Type of the selected Subdomain Record Name"
  type        = string
  default     = "A"
}

variable "subdomain-record-ttl" {
  description = "Subdomain Record TTL of the selected Subdomain Record Name"
  type        = number
  default     = 22
}



####################################
# AWS Region and Availability Zone #
####################################

variable "aws-region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws-availability-zone-suffix" {
  description = "AWS Availability Zone Suffix"
  type        = string
  default     = "c"
}



###########################
# AWS AMI for K8s Node(s) #
###########################

variable "k8s-ami-name-prefix" {
  description = "Prefix of AWS Ubuntu AMI Name"
  type        = string
  default     = "ubuntu/images/*"
}

variable "k8s-ami-name-infix" {
  description = "Infix of AWS Ubuntu AMI Name"
  type        = string
  default     = "*/ubuntu-focal-20.04-amd64-server-*"
}

variable "k8s-ami-name-suffix" {
  description = "Suffix of AWS Ubuntu AMI Name"
  type        = string
  default     = "*"
}

variable "k8s-ami-architecture" {
  description = "Architecture of AWS Ubuntu AMI"
  type        = string
  default     = "x86_64"
}

variable "k8s-ami-virtualization-type" {
  description = "Virtualization Type of AWS Ubuntu AMI"
  type        = string
  default     = "hvm"
}

variable "k8s-ami-owner-id" {
  description = "Owner ID of AWS Ubuntu AMI"
  type        = string
  default     = "099720109477"
}

variable "k8s-ami-most-recent" {
  description = "most-recent of AWS Ubuntu AMI"
  type        = bool
  default     = true
}



###########
# AWS VPC #
###########

variable "aws-vpc-cidr-prefix" {
  description = "The first two IPv4 segments of AWS VPS CIDR Block"
  type        = string
  default     = "10.0"
  # The rest of the CIDR Block will be: ".0.0/16".
  # Such as: "${var.aws-vpc-cidr-prefix}.0.0/16"
}

variable "aws-vpc-tag-name" {
  description = "Name Tag of AWS VPS"
  type        = string
  default     = "aws-vpc-tag-name"
}



########################
# AWS Internet Gateway #
########################

variable "aws-internet-gateway-tag-name" {
  description = "Name Tag of AWS Internet Gateway"
  type        = string
  default     = "aws-internet-gateway-tag-name"
}



###########################
# AWS Route Table / Route #
###########################

variable "aws-route-cidr-any-ipv4" {
  description = "AWS Route CIDR Any IPv4"
  type        = string
  default     = "0.0.0.0/0"
}

variable "aws-route-cidr-any-ipv6" {
  description = "AWS Route CIDR Any IPv6"
  type        = string
  default     = "::/0"
}

variable "aws-public-route-table-tag-name" {
  description = "Name Tag of AWS Route Table for Public Subnet"
  type        = string
  default     = "aws-public-route-table-tag-name"
}

variable "aws-private-route-table-tag-name" {
  description = "Name Tag of AWS Route Table for Private Subnet"
  type        = string
  default     = "aws-private-route-table-tag-name"
}



##############
# AWS Subnet #
##############

variable "aws-public-subnet-cidr-infix" {
  description = "The third IPv4 segments of AWS Subnet CIDR Block"
  type        = number
  default     = 1
  # This will be combined with aws-vpc-cidr-prefix, and the rest of the CIDR Block will be: ".0/24".
  # Such as: "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.0/24"
}

variable "aws-public-subnet-tag-name" {
  description = "Name Tag of AWS Public Subnet"
  type        = string
  default     = "aws-public-subnet-tag-name"
}

variable "aws-private-subnet-cidr-infix" {
  description = "The third IPv4 segments of AWS Subnet CIDR Block"
  type        = number
  default     = 10
  # This will be combined with aws-vpc-cidr-prefix, and the rest of the CIDR Block will be: ".0/24".
  # Such as: "${var.aws-vpc-cidr-prefix}.${var.aws-private-subnet-cidr-infix}.0/24"
}

variable "aws-private-subnet-tag-name" {
  description = "Name Tag of AWS Private Subnet"
  type        = string
  default     = "aws-private-subnet-tag-name"
}



#########################
# AWS Network Interface #
#########################

variable "aws-network-interface-k8s-master1-public-subnet-source-dest-check" {
  description = "Source Destination Check value of AWS Network Interface for K8s Master1 node on the Public Subnet"
  type        = bool
  default     = false
}

variable "aws-network-interface-k8s-master1-public-subnet-private-ip1" {
  description = "The Last Segment of IPv4 of AWS Network Interface for K8s Master1 node on the Public Subnet"
  type        = number
  default     = 123
  # This will be combined with aws-vpc-cidr-prefix, and the aws-public-subnet-cidr-infix.
  # Such as: "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.${var.aws-network-interface-k8s-master1-public-subnet-private-ip1}"
}

variable "aws-network-interface-k8s-master1-public-subnet-tag-name" {
  description = "Tags of AWS Network Interface for K8s Master1 node on the Public Subnet"
  type        = string
  default     = "aws-network-interface-k8s-master1-public-subnet-tag-name"
}









######################
# AWS Security Group #
######################

variable "aws-security-group-ingress-k8s" {
  description = "K8s Ingress Rule for AWS Security Group"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    self             = bool
  }))
  default = [{
    description      = "Allow InComing SSH :"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
    }, {
    description      = "Allow InComing HTTP :"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
    }, {
    description      = "Allow InComing TLS :"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
    }, {
    description      = "Allow InComing K8s NodePorts :"
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
    }, {
    description      = "Allow InComing :"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["127.0.0.0/8"]
    ipv6_cidr_blocks = ["::1/128"]
    self             = true
  }]
}



variable "aws-security-group-ingress-any" {
  description = "Any Ingress Rule for AWS Security Group"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    self             = bool
  }))
  default = [{
    description      = "Allow InComing Any :"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }]
}

variable "aws-security-group-egress-any" {
  description = "Any Egress Rule for AWS Security Group"
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    self             = bool
  }))
  default = [{
    description      = "Allow OutGoing Any :"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    self             = true
  }]
}









################
# AWS Instance #
################

variable "k8s-master1-instance-type" {
  description = "AWS Instance Type for K8s"
  type        = string
  default     = "t3a.medium"
}

variable "k8s-master1-instance-tag-name" {
  description = "Name Tag of AWS Instance"
  type        = string
  default     = "k8s-master1-instance-tag-name"
}

variable "k8s-master1-instance-root-block-device-delete-on-termination" {
  description = "Value of Delete on Termination of Root Block Device of AWS Instance"
  type        = bool
  default     = true
}

variable "k8s-master1-instance-root-block-device-volume-size" {
  description = "Value of Volume Size of Root Block Device of AWS Instance"
  type        = number
  default     = 69
}

variable "k8s-master1-instance-root-block-device-tag-name" {
  description = "Name Tag of Root Block Device of AWS Instance"
  type        = string
  default     = "k8s-master1-instance-root-block-device-tag-name"
}






