


variable "aws-cli-profile" {
  description = "AWS CLI Profile"
  type        = string
}

variable "aws-ec2-keypair-name" {
  description = "AWS EC2 KeyPair"
  type        = string
}



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









