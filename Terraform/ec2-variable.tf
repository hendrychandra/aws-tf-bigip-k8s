


####################################
# Default AWS Security Group (Any) #
####################################

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


