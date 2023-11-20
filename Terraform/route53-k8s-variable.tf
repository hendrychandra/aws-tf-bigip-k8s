


###############
# AWS Route53 #
###############

variable "existing-aws-route53-zone" {
  description = "Existing AWS Route53 DNS Zone"
  type        = string
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


