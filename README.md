# clash

clash
开启混杂模式
``` sh
ip link set eth0 promisc on
```
docker创建网络,注意将网段改为你自己的
``` sh
docker network create -d macvlan --subnet=192.168.50.0/24 --gateway=192.168.50.1 -o parent=eth0 macnet
```
# 推荐部署容器命令
``` sh
docker run --restart=always \
  -d --name clash \
  --privileged=true \
  --net macnet \
  --ip 192.168.50.6 \
  -v /docker/clash:/root/.config/clash \
  -e iptables=true \
  -e tun=false \
  byxiaopeng/clash
```
想要开启tun就把tun变量改成true

路由表改成iptables.sh文件    修改后重启容器即可生效

tun路由表参考

https://lancellc.gitbook.io/clash/start-clash/clash-tun-mode/setup-system-stack-in-real-ip-mode

重启clash容器代码
``` sh
docker restart clash
```
