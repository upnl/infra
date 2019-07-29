UPnL 서버 인프라
========

```
# Requires terraform 0.12.x
terraform init

# IAM 시크릿 확인하기
terraform console <<< 'local.encrypted_access_key'
```
