#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p

#iptables -t nat -N CLASHRULE
#iptables -t nat -A CLASHRULE -d 127.0.0.0/8 -j RETURN
#iptables -t nat -A CLASHRULE -d 192.168.0.0/16 -j RETURN
#iptables -t nat -A CLASHRULE -d 172.17.0.0/24 -j RETURN
#iptables -t nat -A CLASHRULE -d 169.254.0.0/16 -j RETURN
#iptables -t nat -A CLASHRULE -p tcp -j REDIRECT --to-ports 7892
#iptables -t nat -A PREROUTING -p tcp -j CLASHRULE


#tcp
iptables -t nat -N clash
iptables -t nat -A clash -d 0.0.0.0/8 -j RETURN
iptables -t nat -A clash -d 10.0.0.0/8 -j RETURN
iptables -t nat -A clash -d 127.0.0.0/8 -j RETURN
iptables -t nat -A clash -d 169.254.0.0/16 -j RETURN
iptables -t nat -A clash -d 172.16.0.0/12 -j RETURN
iptables -t nat -A clash -d 192.168.0.0/16 -j RETURN
iptables -t nat -A clash -p tcp -j REDIRECT --to-port 7892

iptables -t nat -A PREROUTING -p tcp -j clash

#udp
ip rule add fwmark 1 table 100
ip route add local default dev lo table 100
iptables -t mangle -N clash
iptables -t mangle -A clash -d 0.0.0.0/8 -j RETURN
iptables -t mangle -A clash -d 10.0.0.0/8 -j RETURN
iptables -t mangle -A clash -d 127.0.0.0/8 -j RETURN
iptables -t mangle -A clash -d 169.254.0.0/16 -j RETURN
iptables -t mangle -A clash -d 172.16.0.0/12 -j RETURN
iptables -t mangle -A clash -d 192.168.0.0/16 -j RETURN

iptables -t mangle -A clash -p udp -j TPROXY --on-port 7892 --tproxy-mark 1
iptables -t mangle -A PREROUTING -p udp -j clash

#启动ssh
service ssh restart
#pm2-runtime clash
ip addr
clash


