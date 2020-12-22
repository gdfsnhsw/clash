FROM alpine
RUN apk update	
RUN apk upgrade
RUN apk add --no-cache ca-certificates curl git iptables bash-completion bash unzip	openssh tzdata
ENV VER=2020.12.21
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
#SSH
RUN sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN echo "root:Qq123456" | chpasswd

RUN wget  -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-armv8-$VER.gz
RUN gunzip /usr/bin/clash-linux-armv8-$VER.gz
RUN mv /usr/bin/clash-linux-armv8-$VER /usr/bin/clash
RUN chmod +x /usr/bin/clash

VOLUME /root/.config/clash

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
EXPOSE 22 53 7890 7891 7892 7893 9090
