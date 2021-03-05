FROM alpine
ENV VER=2021.02.21
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN set -ex \
        && apk update && apk upgrade \
        && apk add ca-certificates tzdata wget bash iptables  \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone
#FROM debian
#更新源
#RUN apt-get -y update && apt-get -y upgrade
#RUN apt -y install wget iptables ipset xz-utils
#ENV VER=2021.02.21
#同步系统时间
#RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN wget -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-armv8-$VER.gz
RUN gunzip /usr/bin/clash-linux-armv8-$VER.gz
RUN mv /usr/bin/clash-linux-armv8-$VER /usr/bin/clash
RUN chmod +x /usr/bin/clash
RUN wget -P /tmp https://raw.githubusercontent.com/Hackl0us/GeoIP2-CN/release/Country.mmdb
RUN wget https://github.com/haishanh/yacd/releases/download/v0.2.15/yacd.tar.xz
VOLUME /root/.config/clash
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
EXPOSE 22 53 7890 7891 7892 7893 9090
