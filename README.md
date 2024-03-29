# PalWorld-IPv6-Guide
Hosting PalWorld Server via IPv6 using realm. 使用realm，令PalWorld能使用IPv6开服和连接。
# 简介
目前幻兽帕鲁暂不支持原生IPv6协议栈，国内玩家想开服只能通过购买云服务器或是使用frp穿透服务等方式。\
利用 [realm](https://github.com/zhboner/realm) ，我们可以在服务器端将IPv6流量转发到IPv4绑定的端口上，同时在客户端也使用realm，在本地绑定一个v4端口，转发到远端的IPv6端口上。这样便可实现使用IPv6架设幻兽帕鲁的服务器，玩家仅需要下载一个realm的二进制文件以及配置文件即可加入服务器。\
除了使用realm外，服务端还需要使用一个DDNS工具将其IPv6地址更新到域名上，否则玩家每次都需要重新编辑配置文件修改IPv6地址。可以使用[DDNS-GO](https://github.com/jeessy2/ddns-go)，或是我编写的[Aliyun-DDNS-Clientless](https://github.com/Fawkex/Aliyun-DDNS-Clientless)，前者部署难度较低，后者部署在阿里云函数后，可以方便的在多台机器上使用，只需一个定时执行的脚本即可。其他的DDNS工具自然也是可以的，只要支持IPv6即可。
# 操作流程
## 服务端
这里以Ubuntu-22.04为例，首先下载realm二进制文件。有能力的可以自己参考文档从头编译。Windows服务端参考下面的客户端部分，修改`SERVER`和`LOCAL`参数即可。
### 下载安装 realm 
```
wget https://github.com/zhboner/realm/releases/download/v2.5.2/realm-x86_64-unknown-linux-gnu.tar.gz
tar zxvf realm-x86_64-unknown-linux-gnu.tar.gz
chmod +x realm
sudo mv realm /usr/local/sbin/
```
### 启动 realm
可以直接使用命令启动，无需root权限，或是使用supervisor对其进行管理。
#### 直接命令启动
realm会监听在IPv6的18211端口，将流量转发至IPv4的8211端口
```
realm -l [::]:18211 -r 127.0.0.1:8211 -u
```
#### 安装 Supervisor
```
sudo apt install supervisor
```
#### Supervisor 配置文件
写入到`/etc/supervisor/conf.d/realm.conf`\
写入完成后用`supervisorctl reload`重启supervisor，可以通过`supervisorctl status`查看realm状态。
```
[program:realm]
command=realm -l [::]:18211 -r 127.0.0.1:8211 -u
autostart=true
autorestart=true
```
服务端配置到此完成
## 客户端
客户端配置类似，首先下载realm的二进制文件，在realm的[Releases](https://github.com/zhboner/realm/releases)页面下载`realm-x86_64-pc-windows-gnu.tar.gz`
将realm.exe文件解压到一个目录下，在相同目录下创建一个`launch.bat`文件，用于启动realm。
其中`SERVER`和`LOCAL`字段按自己需要进行修改。双击bat文件即可启动本地转发。
```
@echo off
set SERVER="xxx-pal-server.com:18211"
set LOCAL="127.0.0.1:18211"
echo Port Forwarder running at %LOCAL%
echo Starting...
realm.exe -l %LOCAL% -r %SERVER% -u --dns-mode ipv6_only
```
