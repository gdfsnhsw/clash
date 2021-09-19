#!/bin/bash
# 开启转发
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
sysctl -p

echo -e "======================== 0.1 判断是否安装clash文件 ========================\n"
if [ ! -e '/usr/bin/clash' ]; then
    #clash=$(curl -s https://api.github.com/repos/Dreamacro/clash/releases | jq -r .[]."name" | sed "s/Premium //" | tail -n 18 | grep -m1 -E "([0-9]{1,2}\.?){3,4}$")
    clash=2021.09.15
    echo "当前获取clash版本为$clash"
    if [ $(arch) == aarch64 ]; then     wget -P /usr/bin https://download.fastgit.org/Dreamacro/clash/releases/download/premium/clash-linux-armv8-$clash.gz;     gunzip /usr/bin/clash-linux-armv8-$clash.gz;     mv /usr/bin/clash-linux-armv8-$clash /usr/bin/clash;     chmod +x /usr/bin/clash; fi
    if [ $(arch) == x86_64 ]; then     wget -P /usr/bin https://download.fastgit.org/Dreamacro/clash/releases/download/premium/clash-linux-amd64-$clash.gz;     gunzip /usr/bin/clash-linux-amd64-$clash.gz;     mv /usr/bin/clash-linux-amd64-$clash /usr/bin/clash;     chmod +x /usr/bin/clash; fi
    echo "下载clash完成"
fi
echo -e "======================== 0.2 判断目录是否存在文件 ========================\n"
if [ ! -e '/root/.config/clash/dashboard/index.html' ]; then
    echo "开始移动面板文件到dashboard目录"
    rm -rf /root/.config/clash/dashboard
    mkdir -p /root/.config/clash/dashboard
    wget https://download.fastgit.org/haishanh/yacd/releases/download/v0.3.3/yacd.tar.xz
    tar -xvf yacd.tar.xz
    mv /public/* /root/.config/clash/dashboard
fi

if [ ! -e '/root/.config/clash/Country.mmdb' ]; then
    echo "下载Country.mmdb文件"
    wget -P /root/.config/clash https://hub.fastgit.org/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
fi

if [ ! -e '/root/.config/clash/shell.sh' ]; then
    echo "移动shell.sh文件"
    cp /tmp/shell.sh /root/.config/clash/shell.sh
fi

if [ ! -e '/root/.config/clash/iptables.sh' ]; then
    echo "移动iptables.sh文件"
    cp /tmp/iptables.sh /root/.config/clash/iptables.sh
fi

echo -e "======================== 1. 开始自定义路由表 ========================\n"
if [[ $iptables == true ]]; then
    bash /root/.config/clash/iptables.sh
    echo -e "自定义iptables路由表成功..."
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
    tail -f /dev/null
elif [[ $clash_go == false ]]; then
    echo -e "启动clash成功"
    pm2-docker start clash --name clash
fi
