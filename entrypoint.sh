#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p

# 配置路由表
ip link set utun up
ip address replace 198.18.0.1/16 dev utun
ip route replace default dev utun table 129
ip rule add fwmark 169 table 129

sudo sh -c "nft flush ruleset && nft -f /etc/nftables.conf"

systemctl enable nftables.service

echo -e "======================== 1. 判断目录是否存在文件 ========================\n"
if [ ! -e '/root/.config/clash/dashboard/index.html' ]; then
    echo "开始移动面板文件到dashboard目录"
    unzip gh-pages.zip
    mkdir -p /root/.config/clash/dashboard
    mv /clash-dashboard-gh-pages/* /root/.config/clash/dashboard
fi

if [ ! -e '/root/.config/clash/Country.mmdb' ]; then
    echo "移动Country.mmdb文件"
    cp /tmp/Country.mmdb /root/.config/clash/Country.mmdb
fi

if [ ! -e '/root/.config/clash/shell.sh' ]; then
    echo "移动shell.sh文件"
    cp /tmp/shell.sh /root/.config/clash/shell.sh
fi
echo -e "======================== 2. 自定义shell代码 ========================\n"
if [[ $shell == true ]]; then
    bash /root/.config/clash/shell.sh
    echo -e "自定义shell代码执行成功..."
elif [[ $shell == false ]]; then
    echo -e "自定义shell代码未设置"
fi

echo -e "======================== 3. 是否内核开启tun ========================\n"
if [[ $tun == true ]]; then
    mkdir -p /lib/modules/$(uname -r)
    modprobe tun
    echo -e "如果没有报错就成功开启tun"
elif [[ $tun == false ]]; then
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
