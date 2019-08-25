#!/bin/bash
set -euo pipefail; IFS=$'\n\t'

# Enable verbose mode
set -x

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

#
# 기타 설정
#
sudo -u ec2-user tee /home/ec2-user/README <<'EOF' >/dev/nunll
k3s 관련 바이너리들

    /usr/local/bin/k3s                k3s 바이너리
    /usr/local/bin/k3s-killall.sh
    /usr/local/bin/k3s-uninstall.sh

그 외 커맨드라인 유틸리티들

    /usr/local/bin/kubectl            kubernetes CLI
    /usr/local/bin/ctr                containerd CLI
    /usr/local/bin/crictl             CRI 클라이언트

k3s systemd 유닛 파일

    /etc/systemd/system/k3s.service
    /etc/systemd/system/k3s.service.env

k3s 데이터 위치

    /var/lib/rancher/k3s
    /etc/rancher/k3s

그 외 인스턴스가 어떻게 세팅되었는지는 아래 repo 참고

    https://github.com/upnl/infra
EOF

# 초기 htop 상태 설정
sudo -u ec2-user tee /home/ec2-user/.config/htop <<'EOF' >/dev/nunll
hide_userland_threads=1
tree_view=1
EOF
