#!/bin/bash
set -euo pipefail; IFS=$'\n\t'

#
# 안쓰는 패키지 삭제, 자주 쓰이는 패키지 기본으로 설치
#
yum autoremove -y postfix rpcbind
yum update -y
yum install -y tmux htop

#
# ssh 포트 2222로 변경. 22번 포트는 git.upnl.org이 사용해야한다.
#
KEY=Port
VALUE=2222

if rg -q "^\s*$KEY" /etc/ssh/sshd_config; then
  # 키가 존재함, 찾아바꾸기 수행
  perl -pi -e "s|^\s*($KEY)\s+.*$|\1 $VALUE|g" /etc/ssh/sshd_config
else
  # 키가 존재하지 않음, 파일 하단에 append
  printf '%s %s\n' "$KEY" "$VALUE" >> /etc/ssh/sshd_config
fi

systemctl reload sshd
