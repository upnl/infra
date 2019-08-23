#!/bin/bash
set -euo pipefail; IFS=$'\n\t'

# Enable verbose mode
set -x

#
# Hostname 설정
#
cat <<'EOF' > /etc/cloud/cloud.cfg.d/20_preserve_hostname.cfg
# Hostname을 gemini로 고정하기 위함
preserve_hostname: true
EOF
# /etc/hosts에 매핑 추가
cat <<'EOF' >> /etc/hosts
127.0.0.1 gemini
EOF
# 호스트네임 설정
hostnamectl set-hostname gemini

#
# 안쓰는 패키지 삭제, 자주 쓰이는 패키지 기본으로 설치
#
yum autoremove -y postfix rpcbind
yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
yum update -y
yum install -y tmux htop jq ripgrep

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

#
# sudo 로 /usr/local/{bin,sbin} 안에 있는 커맨드를 실행할 수 있도록 설정
#
cat <<'EOF' > /etc/sudoers.d/10-sudo-path
Defaults secure_path=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
EOF

#
# k3s 설치
#
curl -sfL https://get.k3s.io | sh -
