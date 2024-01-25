# PalWorld-IPv6-Guide
Hosting PalWorld Server via IPv6 using rinetd. 使用rinetd，令PalWorld能使用IPv6开服和连接。
# 简介
目前幻兽帕鲁暂不支持原生IPv6协议栈，国内玩家想开服只能通过购买云服务器或是使用frp穿透服务等方式。\
利用 [rinetd](https://github.com/samhocevar/rinetd) ，我们可以在服务器端将IPv6流量转发到IPv4绑定的端口上，同时在客户端也使用rinetd，在本地绑定一个v4端口，转发到远端的IPv6端口上。这样便可实现使用IPv6架设幻兽帕鲁的服务器，玩家仅需要下载一个rinetd的二进制文件以及配置文件即可加入服务器。
# 操作流程
## 服务端
这里以Ubuntu-22.04为例，首先安装rinetd。**注意，通过apt安装的rinetd并不支持IPv6！**
### 安装编译依赖
```
sudo apt install git build-essential automake
```
### 下载 rinetd 源码并编译安装
```
git clone https://github.com/samhocevar/rinetd
cd rinetd
./bootstrap
./configure
make
sudo make install
```
### 编写 rinetd 配置文件
将以下内容写入 `/etc/rinetd.conf`\
绑定的IPv6端口可以根据自己需要进行修改
```
:: 18211/udp    127.0.0.1 8211/udp

logfile /var/log/rinetd.log
```
### 启动 rinetd
由于编译安装的rinetd没有自带服务，需要手动在开机后运行`rinetd`启动。\
也可以自行编写一个服务，或是像我一样直接用supervisor对rinetd进行管理。
#### 安装 Supervisor
```
sudo apt install supervisor
```
#### Supervisor 配置文件
写入到`/etc/supervisor/conf.d/rinetd.conf`\
写入完成后用`supervisorctl reload`重启supervisor，可以通过`supervisorctl status`查看rinetd状态。
```
[program:rinetd]
command=rinetd -f
autostart=true
autorestart=true
```
服务端配置到此完成
## 客户端
TBD
