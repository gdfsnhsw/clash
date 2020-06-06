#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p
iptables -t nat -N CLASHRULE
iptables -t nat -A CLASHRULE -d 127.0.0.0/8 -j RETURN
iptables -t nat -A CLASHRULE -d 192.168.0.0/16 -j RETURN
iptables -t nat -A CLASHRULE -d 172.17.0.0/24 -j RETURN
iptables -t nat -A CLASHRULE -d 169.254.0.0/16 -j RETURN
iptables -t nat -A CLASHRULE -p tcp -j REDIRECT --to-ports 7892
iptables -t nat -A PREROUTING -p tcp -j CLASHRULE
#启动ssh
service ssh restart
#pm2-runtime /clash/clash-linux-armv8
ip addr
nohup /clash/clash-linux-armv8 >clash.txt 2>&1 &
mkdir /tmp/gost
cd /tmp/gost
wget https://github.com/ginuerzh/gost/releases/download/v2.11.1/gost-linux-armv8-2.11.1.gz
gunzip gost-linux-armv8-2.11.1.gz
chmod +x /tmp/gost/gost-linux-armv8-2.11.1
/tmp/gost/gost-linux-armv8-2.11.1 -L=:8080 -F=kcp://34.80.196.0:8388?tcp=true


