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
  name        = "gemini"
  description = "SG for Gemini"
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

resource "aws_key_pair" "sysadmin" {
  public_key = file("res/upnl_rsa.pub")
}

resource "aws_ebs_volume" "ebs_data" {
  availability_zone = aws_instance.ebony.availability_zone
  size              = 256
}

resource "aws_volume_attachment" "data_ebs_attach" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.ebs_data.id
  instance_id = aws_instance.ebony.id
}

resource "aws_instance" "ebony" {
  ami = data.aws_ami.amazon_linux_2.id

  instance_type          = "t3a.large"
  key_name               = aws_key_pair.sysadmin.key_name
  vpc_security_group_ids = [aws_security_group.ebony.id]
  iam_instance_profile   = aws_iam_instance_profile.ebony.name
  user_data              = file("res/ebony.sh")

  root_block_device {
    volume_size           = 16
    delete_on_termination = false
  }

  tags = {
    Name = "ebony"
  }

  # User data 수정이 인스턴스 재부팅하는것 막기
  #
  # TODO: 향후엔 AWS EFS로 k3s DB파일을 백업해서, 인스턴스가 재부팅되거나
  # 롤링업데이트 되어도 손쉽게 쿠버 상태를 복구할 수 있도록 하자. 그러면 이렇게
  # ignore_changes를 걸 필요가 없다.
  lifecycle {
    ignore_changes = [user_data]
  }
}

resource "aws_eip" "ebony" {
  instance = aws_instance.ebony.id
  vpc      = true
}
