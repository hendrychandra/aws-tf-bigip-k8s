


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
  type        = string
  default     = "1"
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
  type        = string
  default     = "10"
  # This will be combined with aws-vpc-cidr-prefix, and the rest of the CIDR Block will be: ".0/24".
  # Such as: "${var.aws-vpc-cidr-prefix}.${var.aws-private-subnet-cidr-infix}.0/24"
}

variable "aws-private-subnet-tag-name" {
  description = "Name Tag of AWS Private Subnet"
  type        = string
  default     = "aws-private-subnet-tag-name"
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






