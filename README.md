UPnL Infra 
========
[![Terraform Badge]][Terraform Cloud Link]

유피넬의 AWS와 클라우드 플레어 인프라 상태가 정의되어있는 테라폼 코드입니다.

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

### TODOs
- [ ] [cert-manager](https://cert-manager.io) 써서 Traefik Ingress에 HTTPS 지원
      붙이기. 방법은 https://kubernetes.io/docs/concepts/services-networking/ingress/#tls 참고
- [ ] 개발과정에서 릭난 EBS랑 모두 치우기
- [ ] k3s DB 백업만으로 클러스터 복구가 가능한지 확인하기
- [ ] [aws-iam-authenticator](https://github.com/kubernetes-sigs/aws-iam-authenticator) 쓰기

[Terraform Badge]: https://badgen.net/badge/icon/terraform?label&icon=https://unpkg.com/badgen-icons@0.12.0/icons/terraform.svg
[Terraform Cloud Link]: https://app.terraform.io/app/upnl/workspaces/infra
[Terraform Cloud]: https://app.terraform.io
