FROM alpine
RUN apk update	
RUN apk upgrade
RUN apk add --no-cache curl git iptables bash-completion bash unzip	vim tzdata
ENV VER=2020.11.20
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone

RUN wget  -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-armv8-$VER.gz
RUN gunzip /usr/bin/clash-linux-armv8-$VER.gz
RUN mv /usr/bin/clash-linux-armv8-$VER /usr/bin/clash
RUN chmod +x /usr/bin/clash

VOLUME /root/.config/clash

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
EXPOSE 53 7890 7891 7892 7893 9090
