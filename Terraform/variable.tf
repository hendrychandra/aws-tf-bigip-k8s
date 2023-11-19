


# One real example: mistake in assigning IP Address and/or IP Subnet,
# happen quite often. This activity is also meticulous activity which
# needs higher than average attentions.
# Therefore it is best if the script can help by adopting principle of
# "Don't Repeat Yourself" (DRY).
# For example: the whole VPC will have the same Prefix
# (largest is /16). Therefore all Subnets and IP Addresses in the same
# VPC will have the same prefix. By NOT requiring user to re-type the
# Prefix, there are LESS chances of error.
# Example using DRY principle, an IP Address will be composed of VPC
# Prefix, Subnet and the individual IP parts, such as:
# "${var.aws-vpc-cidr-prefix}.${var.aws-public-subnet-cidr-infix}.${var.aws-network-interface-k8s-master1-public-subnet-private-ip1}"
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
  # The availability zone will be: "${var.aws-region}${var.aws-availability-zone-suffix}"
}


