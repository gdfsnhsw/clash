#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p
#重置iptables
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
iptables -t nat -I PREROUTING -p tcp -d 8.8.8.8 -j REDIRECT --to-port 7893
#tcp-udp
ip rule add fwmark 1 table 100
ip route add local default dev lo table 100
iptables -t mangle -N clash
iptables -t mangle -A clash -d 0.0.0.0/8 -j RETURN
iptables -t mangle -A clash -d 10.0.0.0/8 -j RETURN
iptables -t mangle -A clash -d 127.0.0.0/8 -j RETURN
iptables -t mangle -A clash -d 169.254.0.0/16 -j RETURN
iptables -t mangle -A clash -d 172.16.0.0/12 -j RETURN
iptables -t mangle -A clash -d 192.168.0.0/16 -j RETURN
iptables -t mangle -A clash -d 224.0.0.0/4 -j RETURN
iptables -t mangle -A clash -d 240.0.0.0/4 -j RETURN
iptables -t mangle -A clash -p tcp -j TPROXY --on-port 7893 --tproxy-mark 1
iptables -t mangle -A clash -p udp -j TPROXY --on-port 7893 --tproxy-mark 1
iptables -t mangle -A PREROUTING -j clash

if [ ! -e '/root/.config/clash/Country.mmdb' ]; then
    echo "init /root/.config/clash/Country.mmdb"
    cp /tmp/Country.mmdb /root/.config/clashsmartdns.conf/Country.mmdb
fi
#启动DNS服务器
#smartdns -c /root/.config/clash/smartdns.conf
#启动SSH
/etc/init.d/ssh start
#启动 clash
clash
