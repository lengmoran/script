#!/bin/bash

# 1. 创建 id_coding_team 私钥文件
mkdir -p ~/.ssh
cat <<EOL > ~/.ssh/id_coding_team
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCl3A2KMFKIb1GniUalxUHJZF2QdG3erhjFzXI6htDfxgAAAJg9vhPLPb4T
ywAAAAtzc2gtZWQyNTUxOQAAACCl3A2KMFKIb1GniUalxUHJZF2QdG3erhjFzXI6htDfxg
AAAECTrzvmXtWMjJs7BV15N7LOMBYZGos6+HaBLIbXUCtsZaXcDYowUohvUaeJRqXFQclk
XZB0bd6uGMXNcjqG0N/GAAAAEmNhb2x1QHh1emhpc2hpLmNvbQECAw==
-----END OPENSSH PRIVATE KEY-----
EOL

# 2. 创建 config 配置文件
cat <<EOL > ~/.ssh/config
Host e.coding.net
  User git
  IdentityFile ~/.ssh/id_coding_team
  PreferredAuthentications publickey
  IdentitiesOnly yes
EOL

# 3. 设置文件权限
chmod 0600 ~/.ssh/id_coding_team

# 4. 克隆 git 仓库
cd ~/deply || exit
git clone -b feature/stroke git@e.coding.net:xuzhishi/xmp/deploy.git

# 5. 安装依赖并设置权限
cd ~/deply || exit
apt install -y make
chmod -R 775 *
make install

# 6. Docker 登录
docker login -u liyongqiang@xuzhishi.com -p xzs123456! xuzhishi-docker.pkg.coding.net

# 7. 启动服务
make serve
