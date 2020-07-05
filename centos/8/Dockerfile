FROM centos:8.2.2004
LABEL maintainer="metowolf <i@i-meto.com>"

USER root
WORKDIR /root

COPY root /

# 安装 epel 源
RUN dnf install -y epel-release \
  && sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=http://mirrors.cloud.tencent.com/epel/|g' \
    -i.bak \
    /etc/yum.repos.d/epel*.repo

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
  && dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo \
  && dnf install docker-ce-cli -y

# 配置 node 环境
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
  && echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >> /root/.zshrc \ 
  && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.zshrc \
  && source /root/.zshrc \
  && nvm install node \
  && npm i -g yarn

# 清理
RUN dnf clean all \
  && rm -rf /var/cache/yum

CMD [ "/lib/systemd/systemd" ]