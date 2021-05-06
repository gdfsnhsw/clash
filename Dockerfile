FROM alpine
ENV VER=2021.04.08
ENV clash_go=false
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN set -ex \
        && apk update && apk upgrade \
        && apk add ca-certificates tzdata wget bash iptables \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone
RUN if [ $(arch) == aarch64 ]; then     linux=linux-armv8;     wget -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-$linux-$VER.gz;     gunzip /usr/bin/clash-$linux-$VER.gz;     mv /usr/bin/clash-$linux-$VER /usr/bin/clash;     chmod +x /usr/bin/clash; fi
RUN if [ $(arch) == x86_64 ]; then     linux=linux-amd64;     wget -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-$linux-$VER.gz;     gunzip /usr/bin/clash-$linux-$VER.gz;     mv /usr/bin/clash-$linux-$VER /usr/bin/clash;     chmod +x /usr/bin/clash; fi
RUN wget -P /tmp https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
RUN wget https://github.com/haishanh/yacd/releases/download/v0.2.15/yacd.tar.xz
RUN mkdir /etc/supervisor.d
ADD /script/clash.ini /etc/supervisor.d/clash.ini
VOLUME /root/.config/clash
EXPOSE 53 7890 7891 7892 7893 9090
rm -rf /etc/cont-init.d
ADD /s6-overlay/etc/ /etc/
#ADD entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh
#ENTRYPOINT /entrypoint.sh
ENTRYPOINT ["/init"]
