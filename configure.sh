#!/bin/bash
#下载核心程序
mkdir /clash
cd /clash

wget https://byxiaopeng-1251504200.cos.ap-beijing.myqcloud.com/clash/clash-linux-armv8
#设置运行权限
chmod +x /clash/clash-linux-armv8

wget https://byxiaopeng-1251504200.cos.ap-beijing.myqcloud.com/clash/Country.mmdb

wget https://byxiaopeng-1251504200.cos.ap-beijing.myqcloud.com/clash/config.yaml
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p
iptables -t nat -N CLASHRULE

iptables -t nat -A CLASHRULE -d 127.0.0.0/8 -j RETURN
iptables -t nat -A CLASHRULE -d 192.168.50.0/24 -j RETURN
iptables -t nat -A CLASHRULE -p tcp -j REDIRECT --to-ports 7892

# 在 PREROUTING 链前插入 CLASHRULE 链,使其生效
iptables -t nat -A PREROUTING -p tcp -j CLASHRULE
#启动ssh
/etc/init.d/ssh start
/clash/clash-linux-armv8 -d /clash/
