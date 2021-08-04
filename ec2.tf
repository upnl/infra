locals {
  public_ports = ["80", "443", "22", "2222"]
}

data "aws_ami" "amazon_linux_2" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "ena-support"
    values = ["true"]
  }

  # 인스턴스가 매번 재생성되는걸 막기 위해 고정함
  name_regex = "^amzn2-ami-hvm-2.0.20191116.0-x86_64-gp2$"
}

resource "aws_security_group" "ebony" {
  name        = "ebony"
  description = "SG for Ebony server"
}

resource "aws_security_group_rule" "ebony_public_ports" {
  for_each = toset(local.public_ports)

  security_group_id = aws_security_group.ebony.id

  type             = "ingress"
  from_port        = tonumber(each.value)
  to_port          = tonumber(each.value)
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "ebony_egress" {
  security_group_id = aws_security_group.ebony.id

  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_ebs_volume" "ebs_data" {
  availability_zone = "ap-northeast-2c"
  size              = 256
}
