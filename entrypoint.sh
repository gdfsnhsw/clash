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
echo -e "======================== 1. 判断目录是否存在文件 ========================\n"
if [ ! -e '/root/.config/clash/dashboard/index.html' ]; then
    echo "开始移动面板文件到dashboard目录"
    tar -xvf yacd.tar.xz
    mkdir -p /root/.config/clash/dashboard
    mv /public/* /root/.config/clash/dashboard
fi

if [ ! -e '/root/.config/clash/Country.mmdb' ]; then
    echo "移动Country.mmdb文件"
    cp /tmp/Country.mmdb /root/.config/clash/Country.mmdb
fi

if [ ! -e '/root/.config/clash/tun.sh' ]; then
    echo "移动tun.sh文件"
    cp /tmp/tun.sh /root/.config/clash/tun.sh
fi
echo -e "======================== 2. 自定义shell代码 ========================\n"
if [[ $shell == true ]]; then
    bash /root/.config/clash/tun.sh
    echo -e "自定义shell代码执行成功..."
elif [[ $shell == false ]]; then
    echo -e "自定义shell代码未设置"
fi

echo -e "======================== 3. 是否内核开启tun ========================\n"
if [[ $tun == true ]]; then
    mkdir -p /lib/modules/$(uname -r)
    modprobe tun
    echo -e "如果没有报错就成功开启tun"
elif [[ $shell == false ]]; then
    echo -e "你没有设置开启tun变量"
fi
echo -e "======================== 4. 启动clash程序 ========================\n"
if [[ $clash_go == true ]]; then
    apk add supervisor
    supervisord -c /etc/supervisord.conf
    echo -e "supervisord启动clash成功..."
elif [[ $clash_go == false ]]; then
    echo -e "启动clash成功"
    clash
fi
tail -f /dev/null
