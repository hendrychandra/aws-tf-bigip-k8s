


data "aws_ami" "k8s-ami" {
  most_recent = var.k8s-ami-most-recent
  owners      = ["amazon", var.k8s-ami-owner-id]
  filter {
    name   = "architecture"
    values = [var.k8s-ami-architecture]
  }
  filter {
    name   = "name"
    values = [var.k8s-ami-name-prefix]
  }
  filter {
    name   = "name"
    values = [var.k8s-ami-name-infix]
  }
  filter {
    name   = "name"
    values = [var.k8s-ami-name-suffix]
    # Relation between individual-element within the array is/are OR
  }
  filter {
    name   = "virtualization-type"
    values = [var.k8s-ami-virtualization-type]
  }
  # Relation between individual-filter is/are AND
}


