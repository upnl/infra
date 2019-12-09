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

resource "aws_security_group" "gemini" {
  name        = "gemini"
  description = "SG for Gemini"
}

resource "aws_security_group_rule" "gemini_public_ports" {
  for_each = toset(local.public_ports)

  security_group_id = aws_security_group.gemini.id

  type             = "ingress"
  from_port        = tonumber(each.value)
  to_port          = tonumber(each.value)
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "gemini_egress" {
  security_group_id = aws_security_group.gemini.id

  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_key_pair" "sysadmin" {
  public_key = file("res/upnl_rsa.pub")
}

resource "aws_instance" "gemini" {
  ami = data.aws_ami.amazon_linux_2.id

  instance_type        = "t3a.medium"
  key_name             = aws_key_pair.sysadmin.key_name
  security_groups      = [aws_security_group.gemini.name]
  iam_instance_profile = aws_iam_instance_profile.gemini.name
  user_data            = file("res/gemini.sh")

  root_block_device {
    volume_size           = 16
    delete_on_termination = false
  }

  tags = {
    Name = "gemini"

    "kubernetes.io/cluster/gemini" = "owned"
  }
}

resource "aws_eip" "gemini" {
  instance = aws_instance.gemini.id
  vpc      = true
}
