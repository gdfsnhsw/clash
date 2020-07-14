FROM arm64v8/debian
#更新源
RUN apt-get -y update && apt-get -y upgrade
#安装ssh
RUN apt install wget -y
RUN apt install openssh-server -y
RUN apt install iptables -y
RUN apt install dhcpcd5 -y
RUN apt install curl -y
RUN apt install unzip -y
#RUN apt install npm -y
#RUN npm install pm2 -g
#ENV PM2_PUBLIC_KEY lplcipryg41rc37
#ENV PM2_SECRET_KEY s79gu5lz7ermnfs
#同步系统时间
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN echo root:123456789 |chpasswd root

RUN wget  -P /usr/bin https://github.com/Dreamacro/clash/releases/download/v1.0.0/clash-linux-armv8-v1.0.0.gz
RUN gunzip /usr/bin/clash-linux-armv8-v1.0.0.gz
RUN mv /usr/bin/clash-linux-armv8-v1.0.0 /usr/bin/clash

#RUN wget  -P /usr/bin https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-armv8-2020.06.27.gz
#RUN gunzip /usr/bin/clash-linux-armv8-2020.06.27.gz
#RUN mv /usr/bin/clash-linux-armv8-2020.06.27 /usr/bin/clash
RUN chmod +x /usr/bin/clash



VOLUME /root/.config/clash
ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
ENTRYPOINT /configure.sh
EXPOSE 53 7890 7891 7892 8080 9090
