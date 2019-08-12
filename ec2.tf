locals {
  public_ports = [80, 443, 22, 2222]
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["137112412989"] # amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "gemini" {
  name        = "gemini"
  description = "SG for Gemini"
}

resource "aws_security_group_rule" "gemini_public_ports" {
  count = length(local.public_ports)

  security_group_id = aws_security_group.gemini.id

  type        = "ingress"
  from_port   = local.public_ports[count.index]
  to_port     = local.public_ports[count.index]
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_key_pair" "sysadmin" {
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDOJe/gR386HUgk9cUOo39Ch0gipzcXlGWht3E8WUjxh"
}

resource "aws_instance" "gemini" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = "t3a.medium"
  key_name        = aws_key_pair.sysadmin.key_name
  security_groups = [aws_security_group.gemini.id]

  root_block_device {
    volume_size           = 32
    delete_on_termination = false
  }
}
