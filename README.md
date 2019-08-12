UPnL 서버 인프라
========

```bash
# Requires terraform 0.12.6
terraform init

# IAM 시크릿 확인하기
terraform console <<< 'local.encrypted_access_key'
```
