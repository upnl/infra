#!/bin/bash
set -euo pipefail; IFS=$'\n\t'

KEY=Port
VALUE=2222

if rg -q "^\s*$KEY" /etc/ssh/sshd_config; then
  # 키가 존재함, 찾아바꾸기 수행
  perl -pi -e "s|^\s*($KEY)\s+.*$|\1 $VALUE|g" /etc/ssh/sshd_config
else
  # 키가 존재하지 않음, 파일 하단에 append
  printf '%s %s\n' "$KEY" "$VALUE" >> /etc/ssh/sshd_config
fi

# sshd 재시작
systemctl reload sshd
