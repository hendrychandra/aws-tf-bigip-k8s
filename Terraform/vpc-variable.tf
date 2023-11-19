


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



###################
# AWS Network ACL #
###################

# Reference :
# https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html   (search for "Network ACL")
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-networkaclentry.html

variable "aws-network-acl-xgress" {
  description = "Side Attributes of AWS Network ACL"
  type = object({
    rule_no   = number
    action    = string
    protocol  = string
    from_port = number
    to_port   = number
  })
  default = {
    rule_no   = 100
    action    = "allow"
    protocol  = "-1"
    from_port = 0
    to_port   = 0
  }
}

variable "aws-network-acl-xgress-rule-no-ipv6-offset" {
  description = "rule_no Offset for IPv6 CIDR Block of Network ACL"
  type        = number
  default     = 500
}

variable "aws-public-network-acl-xgress-cidr-block" {
  description = "CIDR Block of Network ACL of Public Subnet"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "aws-public-network-acl-xgress-ipv6-cidr-block" {
  description = "IPv6 CIDR Block of Network ACL of Public Subnet"
  type        = list(string)
  default     = ["::/0"]
}

variable "aws-public-network-acl-tag-name" {
  description = "Tag Name of Network ACL of Public Subnet"
  type        = string
  default     = "aws-public-network-acl-tag-name"
}


