FROM fedora:33
LABEL maintainer="metowolf <i@i-meto.com>"

USER root
WORKDIR /root

COPY root /

RUN set -e

# 安装常见工具
RUN dnf update -y \
  && dnf install bind-utils crontabs curl make jq unzip vim wget -y

# 配置 SSH
RUN dnf install openssh-server -y \
  && sed -i -r 's/^\s*#?\s*UsePAM\s*yes/UsePAM no/' /etc/ssh/sshd_config \
  && systemctl enable sshd \
  && dnf install passwd cracklib-dicts -y \
  && uuidgen | passwd --stdin root

# 配置 ohmyzsh
RUN dnf install git zsh util-linux-user diffutils -y \
  && curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh \
  && chsh -s /usr/bin/zsh

# 配置 Docker CLI
RUN dnf install 'dnf-command(config-manager)' -y \
  && dnf config-manager --add-repo=https://download.docker.com/linux/fedora/docker-ce.repo \
  && dnf install docker-ce-cli -y

# 配置 node 环境
RUN curl -sL https://rpm.nodesource.com/setup_15.x | bash - \
  && yum install -y nodejs \
  && npm i -g yarn

# 配置 deno 环境
RUN curl -fsSL https://deno.land/x/install/install.sh | sh \
  && echo 'export PATH="$PATH:${HOME}/.deno/bin/"' >> /root/.zshrc

# 清理
RUN dnf clean all \
  && rm -rf /var/cache/yum

CMD [ "/lib/systemd/systemd" ]