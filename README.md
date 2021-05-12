# clash

clash

开启混杂模式

ip link set eth0 promisc on

docker创建网络,注意将网段改为你自己的

docker network create -d macvlan --subnet=192.168.50.0/24 --gateway=192.168.50.1 -o parent=eth0 macnet
``` sh
# 推荐使用命令
docker -itd \
  -d --name clash \
  --restart=always \
  --privileged=true \
  --net macnet \
  --ip 192.168.50.66 \
  -v /docker/clash:/root/.config/clash \
  - shell=false \
  - clash_go=false \
  byxiaopeng/clash
```
# 如果想自定义shell脚本 请把变量shell设置成true  并且在映射的/docker/clash目录里面新建tun.sh
