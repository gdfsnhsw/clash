#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p
#重置iptables
#iptables -P INPUT ACCEPT
#iptables -P FORWARD ACCEPT
#iptables -P OUTPUT ACCEPT
#iptables -t nat -F
#iptables -t mangle -F
#iptables -F
#iptables -X

#tcp
#iptables -t nat -N clash
#iptables -t nat -A clash -d 0.0.0.0/8 -j RETURN
#iptables -t nat -A clash -d 10.0.0.0/8 -j RETURN
#iptables -t nat -A clash -d 127.0.0.0/8 -j RETURN
#iptables -t nat -A clash -d 169.254.0.0/16 -j RETURN
#iptables -t nat -A clash -d 172.16.0.0/12 -j RETURN
#iptables -t nat -A clash -d 192.168.0.0/16 -j RETURN
#iptables -t nat -A clash -d 224.0.0.0/4 -j RETURN
#iptables -t nat -A clash -d 240.0.0.0/4 -j RETURN
#iptables -t nat -A clash -p tcp -j REDIRECT --to-port 7892

#iptables -t nat -A PREROUTING -p tcp -j clash

#udp
#ip rule add fwmark 1 table 100
#ip route add local default dev lo table 100
#iptables -t mangle -N clash
#iptables -t mangle -A clash -d 0.0.0.0/8 -j RETURN
#iptables -t mangle -A clash -d 10.0.0.0/8 -j RETURN
#iptables -t mangle -A clash -d 127.0.0.0/8 -j RETURN
#iptables -t mangle -A clash -d 169.254.0.0/16 -j RETURN
#iptables -t mangle -A clash -d 172.16.0.0/12 -j RETURN
#iptables -t mangle -A clash -d 192.168.0.0/16 -j RETURN
#iptables -t mangle -A clash -d 224.0.0.0/4 -j RETURN
#iptables -t mangle -A clash -d 240.0.0.0/4 -j RETURN
#iptables -t mangle -A clash -p udp -j TPROXY --on-port 7892 --tproxy-mark 1
#iptables -t mangle -A PREROUTING -p udp -j clash


ipset create localnetwork hash:net
ipset add localnetwork 127.0.0.0/8
ipset add localnetwork 10.0.0.0/8
ipset add localnetwork 169.254.0.0/16
ipset add localnetwork 192.168.0.0/16
ipset add localnetwork 224.0.0.0/4
ipset add localnetwork 240.0.0.0/4
ipset add localnetwork 172.16.0.0/12
ip tuntap add user root mode tun utun0
ip link set utun0 up
ip address replace 172.31.255.253/30 dev utun0
ip route replace default dev utun0 table 0x162
ip rule add fwmark 0x162 lookup 0x162
iptables -t mangle -N CLASH
iptables -t mangle -F CLASH
iptables -t mangle -A CLASH -d 198.18.0.0/16 -j MARK --set-mark 0x162
iptables -t mangle -A CLASH -m addrtype --dst-type BROADCAST -j RETURN
iptables -t mangle -A CLASH -m set --match-set localnetwork dst -j RETURN
iptables -t mangle -A CLASH -j MARK --set-mark 0x162
iptables -t nat -N CLASH_DNS
iptables -t nat -F CLASH_DNS 
iptables -t nat -A CLASH_DNS -p udp -j REDIRECT --to-port 1053
iptables -t mangle -I OUTPUT -j CLASH
iptables -t mangle -I PREROUTING -m set ! --match-set localnetwork dst -j MARK --set-mark 0x162
iptables -t nat -I OUTPUT -p udp --dport 53 -j CLASH_DNS
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to 1053
iptables -t filter -I OUTPUT -d 172.31.255.253/30 -j REJECT
#启动ssh
service ssh restart
#pm2-runtime clash
clash
