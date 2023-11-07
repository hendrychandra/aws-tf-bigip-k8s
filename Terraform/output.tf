


output "ubuntu-20-ami" {
  value = data.aws_ami.ubuntu-20-ami-terraform-test.arn
}

output "public_ip" {
  value = aws_eip.public-gw-eip-terraform-test.public_ip
}


