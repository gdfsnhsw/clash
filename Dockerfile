FROM alpine
ENV VER=2021.07.03
ENV iptables=true
ENV tun=false
ENV shell=false
ENV clash_go=false
RUN set -ex \
        && apk update && apk upgrade \
        && apk add ca-certificates tzdata wget bash iptables nodejs-current npm \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && npm install -g pm2
RUN if [ $(arch) == aarch64 ]; then     linux=linux-armv8;     wget -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-$linux-$VER.gz;     gunzip /usr/bin/clash-$linux-$VER.gz;     mv /usr/bin/clash-$linux-$VER /usr/bin/clash;     chmod +x /usr/bin/clash; fi
RUN if [ $(arch) == x86_64 ]; then     linux=linux-amd64;     wget -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-$linux-$VER.gz;     gunzip /usr/bin/clash-$linux-$VER.gz;     mv /usr/bin/clash-$linux-$VER /usr/bin/clash;     chmod +x /usr/bin/clash; fi
RUN wget https://github.com/haishanh/yacd/releases/download/v0.3.2/yacd.tar.xz
RUN if [ $(arch) == aarch64 ]; then     down=smartdns-aarch64;     wget https://github.com/pymumu/smartdns/releases/download/Release33/$down;     chmod +x /$down;     mv /$down /usr/bin/smartdns; fi 
RUN if [ $(arch) == x86_64 ]; then     down=smartdns-x86_64;     wget https://github.com/pymumu/smartdns/releases/download/Release33/$down;     chmod +x /$down;     mv /$down /usr/bin/smartdns; fi
RUN mkdir /etc/supervisor.d
ADD /script/clash.ini /etc/supervisor.d/clash.ini
ADD /script/shell.sh /tmp/shell.sh
ADD /script/iptables.sh /tmp/iptables.sh
RUN chmod +x /tmp/shell.sh
RUN chmod +x /tmp/iptables.sh
VOLUME /root/.config/clash
EXPOSE 53 7890 7891 7892 7893 9090
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
