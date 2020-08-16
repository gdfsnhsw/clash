FROM arm64v8/alpine

RUN apk update

RUN apk add --no-cache --virtual .build-deps ca-certificates curl iptables bash-completion bash unzip
ENV VER=2020.08.16

#FROM arm64v8/debian
#更新源
#RUN apt-get -y update && apt-get -y upgrade
#安装ssh
#RUN apt install -y wget openssh-server iptables curl unzip
#同步系统时间
RUN apk add tzdata
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
RUN apk del tzdata

#RUN sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
#RUN echo root:123456789 |chpasswd root

#RUN wget  -P /usr/bin https://github.com/Dreamacro/clash/releases/download/v1.0.0/clash-linux-armv8-v1.0.0.gz
#RUN gunzip /usr/bin/clash-linux-armv8-v1.0.0.gz
#RUN mv /usr/bin/clash-linux-armv8-v1.0.0 /usr/bin/clash

RUN wget  -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-armv8-$VER.gz
RUN gunzip /usr/bin/clash-linux-armv8-$VER.gz
RUN mv /usr/bin/clash-linux-armv8-$VER /usr/bin/clash
RUN chmod +x /usr/bin/clash

VOLUME /root/.config/clash

ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
ENTRYPOINT /configure.sh
EXPOSE 53 7890 7891 7892 9090
