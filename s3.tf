resource "aws_s3_bucket" "backups" {
  bucket = "upnl-backups"

  ## 자동 백업이 세팅되면 아래와 같은 방식으로 Lifecycle Rule을 만들어줍시다
  #lifecycle_rule {
  #  enabled = true
  #  id      = "Transition UPnL Homepage backups to Glacier Deep Archive after 14 days"
  #  prefix  = "upnl.org/"
  #
  #  # NOTE: STANDARD_IA 를 사용할 경우, S3 IA로 가는순간 30일치 요금이 무조건
  #  # 계산된다는 점을 주의해주세요. Glacier로 보내게 될 경우, 90일이 지나야
  #  # Glacier Deep Archive로 이동시킬 수 있습니다.
  #
  #  transition {
  #    days          = 14
  #    storage_class = "DEEP_ARCHIVE"
  #  }
  #}
}

resource "aws_s3_bucket_public_access_block" "backups" {
  bucket = aws_s3_bucket.backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
