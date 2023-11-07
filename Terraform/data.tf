


data "aws_ami" "ubuntu-20-ami-terraform-test" {
  most_recent = true
  owners      = ["amazon", "099720109477"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/*"]
  }
  filter {
    name   = "name"
    values = ["*/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


