#!/bin/bash

# 获取本地网络接口的IPv4地址，过滤出10.168.*.100
SERVER_IP=$(ip -4 addr | grep -oP '(?<=inet\s)10\.168\.\d+\.100' | head -n 1)

# 如果没有找到匹配的IP，则退出脚本
if [ -z "$SERVER_IP" ]; then
  echo "No appropriate IP address found."
  exit 1
fi

# 通过截断最后一个八位组获取子网地址
SUBNET="${SERVER_IP%.*}.0/24"

# 创建并配置99-tailscale.conf文件
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf

# 应用sysctl配置
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

# 使用广告路由启动Tailscale
sudo tailscale up --advertise-routes=$SUBNET --accept-routes --login-server=https://lan.xuzhishi.com

