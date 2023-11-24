


######################
# AWS Security Group #
######################

variable "k8s-worker-public-security-group-name" {
  description = "Name for Public Security Group"
  type        = string
  default     = "k8s-worker-public-security-group-name"
}

variable "k8s-worker-public-security-group-tag-name" {
  description = "Name Tag for Public Security Group"
  type        = string
  default     = "k8s-worker-public-security-group-tag-name"
}

variable "k8s-worker-public-security-group-description" {
  description = "Description for Public Security Group"
  type        = string
  default     = "Allow K8s and Administrative Traffic"
}

variable "k8s-worker-public-security-group-ingress" {
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



#########################
# AWS Network Interface #
#########################

variable "k8s-worker-public-network-interface-source-dest-check" {
  description = "Source Destination Check value of AWS Network Interface for K8s worker1 node on the Public Subnet"
  type        = bool
  default     = false
}

variable "k8s-worker-public-network-interface-tag-name" {
  description = "Name Tag for AWS Network Interface for K8s worker1 node on the Public Subnet"
  type        = string
  default     = "k8s-worker-public-network-interface-tag-name"
}

# Only one IP Address is supported per K8s Worker Node,
# each with its own Domain Name.
# So the number of IP Addresses below represent the number of
# K8s Worker Nodes. Only 0 (zero) up to 9 (nine) K8s Worker Nodes are
# supported in this template implementation.

variable "k8s-worker-public-network-interface-private-ips" {
  description = "The Last Segment of IPv4 of AWS Network Interface for K8s worker1 node on the Public Subnet"
  type        = map(number)
  # Since the key is of string value, internally the map will be
  # stored with the key string value sorted in ascending order.
  # Therefore, you may need to give the key string (i.e. sub domain
  # name) in ascending order along with the IP Address order (i.e.
  # Last Segment of IPv4).
  default = {
    "worker-a" = 201
    "worker-b" = 202
    "worker-c" = 203
  }
  # This will be combined with aws-vpc-cidr-prefix, and the aws-public-subnet-cidr-infix.
  # Such as: "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.${var.k8s-worker-public-network-interface-private-ips}"
}



##################
# AWS Elastic IP #
##################

variable "k8s-worker-public-eip-tag-name" {
  description = "Name Tag for AWS EIP for K8s worker1 node on the Public Subnet"
  type        = string
  default     = "k8s-worker-public-eip-tag-name"
}



################
# AWS Instance #
################

variable "k8s-worker-instance-type" {
  description = "AWS Instance Type for K8s"
  type        = string
  default     = "t3a.medium"
}

variable "k8s-worker-instance-tag-name" {
  description = "Name Tag of AWS Instance"
  type        = string
  default     = "k8s-worker-instance-tag-name"
}

variable "k8s-worker-instance-root-block-device-delete-on-termination" {
  description = "Value of Delete on Termination of Root Block Device of AWS Instance"
  type        = bool
  default     = true
}

variable "k8s-worker-instance-root-block-device-volume-size" {
  description = "Value of Volume Size of Root Block Device of AWS Instance"
  type        = number
  default     = 69
}

variable "k8s-worker-instance-root-block-device-tag-name" {
  description = "Name Tag of Root Block Device of AWS Instance"
  type        = string
  default     = "k8s-worker-instance-root-block-device-tag-name"
}


