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

resource "aws_security_group_rule" "gemini_egress" {
  security_group_id = aws_security_group.gemini.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_key_pair" "sysadmin" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCb5aPHLwBWdriec8UADgXJuwqEABFPMHe2wCJiLSOJpIJuzigLWtdJns7hEPdk5FUEyuxsTd3VRgp97Axu8OG461rew0zTnWBBYHwsmwx9A+4T9TVynfTi5IBzy3tXaVwFJ1SxmdJvAe/s6Yk8qEM9eMcNMYYWao48wo0t/7tNpRHTR6VU4nYUDBM0SK6C8fmykslQXvmeaKRhMRAcE46Y01gkdc/0uD4rJlmr3nuAe2/DWqUPF49hE7dR35MTgjT1kxfiRN3sli3AqGbXAZS0GSu9ntCg6iAsPV0D8PJVb8Jc25M5/LFp6mKqQ5rhnfTvK7nd/+daMNb61z42/AnRydNRd6jUeofLAR0KDKNyNRuhilprkoOG2PIOvR5HW5PPLoT+R/SiReDWLqFAUF8ATvFDaUjyEDBkQwedByHnudAk/5zbPjo2tmJn6Csjih3mexnL9e3kHYsuMZHTSF+FFNc32MWTggb6a4YY6d7SLJUc0IEbtPiYMWFOXe4SGc="
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
