


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


