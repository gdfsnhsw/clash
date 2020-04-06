FROM arm64v8/debian
#更新源
RUN apt-get -y update && apt-get -y upgrade
#安装ssh
RUN apt install wget -y
RUN apt install openssh-server -y
RUN apt install iptables -y
RUN apt install npm -y
RUN npm install pm2 -g
ENV PM2_PUBLIC_KEY lplcipryg41rc37
ENV PM2_SECRET_KEY s79gu5lz7ermnfs
#同步系统时间
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN echo root:123456789 |chpasswd root
RUN wget -P /root/.config/clash https://cdn.jsdelivr.net/gh/byxiaopeng/imgtu/pz/config.yaml
RUN wget -P /root/.config/clash https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb

ADD clash-linux-armv8 clash/clash-linux-armv8
RUN chmod +x clash/clash-linux-armv8

VOLUME /root/.config/clash
ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
ENTRYPOINT /configure.sh
