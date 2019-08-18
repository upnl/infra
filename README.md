UPnL 서버 인프라
========

### Prerequisites
- Terraform 0.12.6+
- [Terraform Cloud] 계정
- AWS 크레덴셜
- Cloudflare 크레덴셜 (`CLOUDFLARE_EMAIL`, `CLOUDFLARE_TOKEN`)

### Instructions
```bash
# https://app.terraform.io/app/settings/tokens 에서 본인의 토큰을 확인한 뒤
# ~/.terraformrc 에 아래와 같이 테라폼 토큰 세팅
#
#     credentials "app.terraform.io" {
#       token = "xxxxxxxxxxxxxx.atlasv1.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#     }

terraform init

# IAM 시크릿 확인하기
terraform console <<< local.iam_secrets
terraform console <<< local.iam_secrets.simnalamburt
```

[Terraform Cloud]: https://app.terraform.io
