#!/bin/sh

set -ex

# 修改源
sed -e 's|#?\s*mirrorlist=|#mirrorlist=|g' \
    -e 's|#?\s*baseurl\s*=\s*http://[^\$]+\$contentdir|baseurl=https://mirrors.cloud.tencent.com/centos|g' \
    -e 's|#?\s*gpgcheck=.*|gpgcheck=0|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-*.repo

dnf install -y epel-release
sed -e 's|#?\s*metalink=|#metalink=|g' \
    -e 's|#?\s*baseurl\s*=\s*https?://[^\$]+\$releasever|baseurl=http://mirrors.cloud.tencent.com/epel/\$releasever|g' \
    -i.bak \
    /etc/yum.repos.d/epel*.repo

# 升级软件
dnf update -y

# 安装常规工具
dnf install bind-utils crontabs curl wget unzip -y

# 配置 SSH
dnf install openssh-server -y
sed -i -r 's/^\s*#?\s*UsePAM\s*yes/UsePAM no/' /etc/ssh/sshd_config
systemctl enable sshd

# 配置密码
dnf install passwd cracklib-dicts -y
uuidgen | passwd --stdin root

# 安装 ohmyzsh
dnf install git zsh util-linux-user diffutils -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /usr/bin/zsh

# 配置 linuxbrew
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> ~/.zshrc

# 配置 Docker CLI
dnf install 'dnf-command(config-manager)' -y
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install docker-ce-cli -y

# 清理
dnf clean all
rm -rf /var/cache/yum