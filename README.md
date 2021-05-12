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
  --ip 192.168.50.66 \
  -v /docker/clash:/root/.config/clash \
  -e tun=false \
  -e shell=false \
  -e clash_go=false \
  byxiaopeng/clash
```
想要开启tun就把tun变量改成true

修改tun.sh脚本文件并重启容器

docker restart clash
