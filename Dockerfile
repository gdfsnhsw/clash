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


RUN sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN echo root:123456789 |chpasswd root

ADD Country.mmdb /root/.config/clash/Country.mmdb

ADD config.yaml /root/.config/clash/config.yaml

ADD clash-linux-armv8 clash/clash-linux-armv8
RUN chmod +x clash/clash-linux-armv8
VOLUME /root/.config/clash
ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
ENTRYPOINT /configure.sh
