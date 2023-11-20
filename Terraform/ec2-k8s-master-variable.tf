


######################
# AWS Security Group #
######################

variable "k8s-master-public-security-group-name" {
  description = "Name for Public Security Group"
  type        = string
  default     = "k8s-master-public-security-group-name"
}

variable "k8s-master-public-security-group-tag-name" {
  description = "Name Tag for Public Security Group"
  type        = string
  default     = "k8s-master-public-security-group-tag-name"
}

variable "k8s-master-public-security-group-description" {
  description = "Description for Public Security Group"
  type        = string
  default     = "Allow K8s and Administrative Traffic"
}

variable "k8s-master-public-security-group-ingress" {
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



variable "k8s-master-private-security-group-name" {
  # The 'Name' property is NOT the default first column on AWS Dashboard/Portal/UI
  description = "Name for Private Security Group"
  type        = string
  default     = "k8s-master-private-security-group-name"
}

variable "k8s-master-private-security-group-tag-name" {
  # The default first column on AWS Dashboard/Portal/UI is Name Tag
  description = "Name Tag for Private Security Group"
  type        = string
  default     = "k8s-master-private-security-group-tag-name"
}

variable "k8s-master-private-security-group-description" {
  description = "Description for Private Security Group"
  type        = string
  default     = "Allow All Traffic"
}



#########################
# AWS Network Interface #
#########################

variable "k8s-master-public-network-interface-source-dest-check" {
  description = "Source Destination Check value of AWS Network Interface for K8s Master1 node on the Public Subnet"
  type        = bool
  default     = false
}

variable "k8s-master-public-network-interface-tag-name" {
  description = "Name Tag for AWS Network Interface for K8s Master1 node on the Public Subnet"
  type        = string
  default     = "k8s-master-public-network-interface-tag-name"
}

variable "k8s-master-public-network-interface-private-ips" {
  description = "The Last Segment of IPv4 of AWS Network Interface for K8s Master1 node on the Public Subnet"
  type        = map(number)
  default = {
    "demo" = 11
  }
  # This will be combined with aws-vpc-cidr-prefix, and the aws-public-subnet-cidr-infix.
  # Such as: "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.${var.k8s-master-public-network-interface-private-ips}"
}



variable "k8s-master-private-network-interface-source-dest-check" {
  description = "Source Destination Check value of AWS Network Interface for K8s Master1 node on the Private Subnet"
  type        = bool
  default     = false
}

variable "k8s-master-private-network-interface-private-ips" {
  description = "The Last Segment of IPv4 of AWS Network Interface for K8s Master1 node on the Private Subnet"
  type        = list(number)
  default     = [11]
  # This will be combined with aws-vpc-cidr-prefix, and the aws-private-subnet-cidr-infix.
  # Such as: "${var.aws-vpc-cidr-prefix}.${var.aws-private-subnet-cidr-infix}.${var.k8s-master-private-network-interface-private-ips}"
}

variable "k8s-master-private-network-interface-tag-name" {
  description = "Name Tag for AWS Network Interface for K8s Master1 node on the Private Subnet"
  type        = string
  default     = "k8s-master-private-network-interface-tag-name"
}



##################
# AWS Elastic IP #
##################

variable "k8s-master-public-eip-tag-name" {
  description = "Name Tag for AWS EIP for K8s Master1 node on the Public Subnet"
  type        = string
  default     = "k8s-master-public-eip-tag-name"
}



################
# AWS Instance #
################

variable "k8s-master-instance-type" {
  description = "AWS Instance Type for K8s"
  type        = string
  default     = "t3a.medium"
}

variable "k8s-master-instance-tag-name" {
  description = "Name Tag of AWS Instance"
  type        = string
  default     = "k8s-master-instance-tag-name"
}

variable "k8s-master-instance-root-block-device-delete-on-termination" {
  description = "Value of Delete on Termination of Root Block Device of AWS Instance"
  type        = bool
  default     = true
}

variable "k8s-master-instance-root-block-device-volume-size" {
  description = "Value of Volume Size of Root Block Device of AWS Instance"
  type        = number
  default     = 69
}

variable "k8s-master-instance-root-block-device-tag-name" {
  description = "Name Tag of Root Block Device of AWS Instance"
  type        = string
  default     = "k8s-master-instance-root-block-device-tag-name"
}


