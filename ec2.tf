locals {
  public_ports = ["80", "443", "22", "2222"]
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

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_key_pair" "sysadmin" {
  public_key = file("${path.module}/upnl_rsa.pub")
}

resource "aws_instance" "gemini" {
  ami               = data.aws_ami.amazon_linux_2.id
  instance_type     = "t3a.medium"
  availability_zone = "ap-northeast-2a"
  key_name          = aws_key_pair.sysadmin.key_name
  security_groups   = [aws_security_group.gemini.name]

  root_block_device {
    volume_size           = 16
    delete_on_termination = false
  }

  user_data = file("${path.module}/gemini.sh")
}

resource "aws_eip" "gemini" {
  instance = aws_instance.gemini.id
  vpc      = true
}

locals {
  gemini_ebs_volumes = {
    "upnl.org upload"   = { size = 10, device_name = "/dev/sdf" },
    "upnl.org postgres" = { size = 1, device_name = "/dev/sdg" },
    "gitlab"            = { size = 20, device_name = "/dev/sdh" },
    "pokemon sqlite"    = { size = 1, device_name = "/dev/sdi" },
    "helix upload"      = { size = 1, device_name = "/dev/sdj" },
    "helix postgres"    = { size = 1, device_name = "/dev/sdk" },
  }
}

resource "aws_ebs_volume" "gemini_ebs" {
  for_each = local.gemini_ebs_volumes

  availability_zone = aws_instance.gemini.availability_zone
  size              = each.value.size

  tags = {
    Name = each.key
  }
}

resource "aws_volume_attachment" "gemini_ebs_att" {
  for_each = local.gemini_ebs_volumes

  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.gemini_ebs[each.key].id
  instance_id = aws_instance.gemini.id
}
