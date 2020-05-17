FROM metowolf/linuxbrew:centos-8
LABEL maintainer="metowolf <i@i-meto.com>"

USER root
WORKDIR /root

COPY root /
RUN /install/auto.sh

CMD [ "/lib/systemd/systemd" ]