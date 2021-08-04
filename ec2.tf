resource "aws_ebs_volume" "ebs_data" {
  availability_zone = "ap-northeast-2c"
  size              = 256
}
