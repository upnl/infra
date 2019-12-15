UPnL Infra 
========
[![Terraform Badge]][Terraform Cloud Link]

유피넬의 AWS와 클라우드 플레어 인프라 상태가 정의되어있는 테라폼 코드입니다. 쿠버네티스 YAML 파일들은 [upnl/kubernetes](https://github.com/upnl/kubernetes)에서 확인하세요.

### Prerequisites
- Terraform 0.12.6+
- [Terraform Cloud] 계정
- AWS 크레덴셜
- [Cloudflare Global API Key](https://dash.cloudflare.com/profile/api-tokens)
  (`CLOUDFLARE_EMAIL`, `CLOUDFLARE_API_KEY`)

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

[Terraform Badge]: https://badgen.net/badge/icon/terraform?label&icon=https://unpkg.com/badgen-icons@0.12.0/icons/terraform.svg
[Terraform Cloud Link]: https://app.terraform.io/app/upnl/workspaces/infra
[Terraform Cloud]: https://app.terraform.io
