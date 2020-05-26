#!/bin/sh

set -ex

# 修改源
test -f /etc/yum.repos.d/fedora-cisco-openh264.repo && rm /etc/yum.repos.d/fedora-cisco-openh264.repo
sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.cloud.tencent.com/fedora|g' \
    -i.bak \
    /etc/yum.repos.d/fedora*.repo

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
dnf config-manager --add-repo=https://download.docker.com/linux/fedora/docker-ce.repo
dnf install docker-ce-cli -y

# 清理
dnf clean all
rm -rf /var/cache/yum