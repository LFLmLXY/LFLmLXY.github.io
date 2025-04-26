---
title: "锐捷校园网——实现多设备上网"
date: 2025-03-28T18:13:42+08:00
lastmod: 2025-04-06T11:04:00+08:00
draft: false # 是否为草稿
author: ["LFL"] #文章作者

categories: ["校园网防检测"] #文章分类

tags: ["openwrt","Pi 5"] #文章标签

keywords: []

description: "" # 文章描述，与搜索优化相关
summary: "" # 文章简单描述，会展示在主页
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
comments: true # 是否启用评论系统
autoNumbering: true # 目录自动编号
hideMeta: false # 是否隐藏文章的元信息，如发布日期、作者等
mermaid: true
cover:
    image: ""
    caption: ""
    alt: ""
    relative: false
---

<meta name="referrer" content="no-referrer" />

# 前言

我这里使用的是树莓派烧录的openwrt，本地编译我试了很多次，都失败了，我建议小白就去大神搭建的云编译平台[openwrt](https://openwrt.ai/)。烧录固件的软件我用的树莓派官方的烧录器。

# 云编译

[openwrt](https://openwrt.ai/)。填上我们需要的一些软件包，把后面的**ipv6**打上勾，之后就是下载->烧录->启动

```bash
luci-app-ttyd mod-rkp-ipid iptables-mod-filter iptables-mod-ipopt iptables-mod-u32 iptables-nft kmod-ipt-ipopt ipset iptables-mod-conntrack-extra
```

![image-20250328183258795](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250328183258795.png)



## 联网

开机之后，用电脑连接上wifi名字叫**Kwrt_5G**，然后用网线让树莓派连接上校园网，增加一个wan口。wan口设备选择的是br-lan口，用的dhcp协议

![image-20250328184509650](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250328184509650.png)

之后会跳出认证界面，这个认证界面的mac地址是树莓派的地址，登录你的账号密码，就可以上网了

## 设置ntp服务器

![image-20250328184146069](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250328184146069.png)

```
ntp.aliyun.com
time1.cloud.tencent.com
time.ustc.edu.cn
cn.pool.ntp.org
```

## 添加开机启动脚本

![image-20250328184305879](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250328184305879.png)

```
# 启动 UA3F
uci set ua3f.enabled.enabled=1
uci commit ua3f
service ua3f enable
service ua3f start

#防火墙：
iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53

# 防 IPID 检测
iptables -t mangle -N IPID_MOD
iptables -t mangle -A FORWARD -j IPID_MOD
iptables -t mangle -A OUTPUT -j IPID_MOD
iptables -t mangle -A IPID_MOD -d 0.0.0.0/8 -j RETURN
iptables -t mangle -A IPID_MOD -d 127.0.0.0/8 -j RETURN
# 由于本校局域网是 A 类网，所以我将这一条注释掉了，具体要不要注释结合你所在的校园网内网类型
# iptables -t mangle -A IPID_MOD -d 10.0.0.0/8 -j RETURN
iptables -t mangle -A IPID_MOD -d 172.16.0.0/12 -j RETURN
iptables -t mangle -A IPID_MOD -d 192.168.0.0/16 -j RETURN
iptables -t mangle -A IPID_MOD -d 255.0.0.0/8 -j RETURN
iptables -t mangle -A IPID_MOD -j MARK --set-xmark 0x10/0x10

# 防时钟偏移检测
iptables -t nat -N ntp_force_local
iptables -t nat -I PREROUTING -p udp --dport 123 -j ntp_force_local
iptables -t nat -A ntp_force_local -d 0.0.0.0/8 -j RETURN
iptables -t nat -A ntp_force_local -d 127.0.0.0/8 -j RETURN
iptables -t nat -A ntp_force_local -d 192.168.0.0/16 -j RETURN
iptables -t nat -A ntp_force_local -s 192.168.0.0/16 -j DNAT --to-destination 192.168.1.1

# 通过 iptables 修改 TTL 值
iptables -t mangle -A POSTROUTING -j TTL --ttl-set 64

# iptables 拒绝 AC 进行 Flash 检测
# iptables -I FORWARD -p tcp --sport 80 --tcp-flags ACK ACK -m string --algobm --string " src=\"http://1.1.1." -j DROP
iptables -A FORWARD -p tcp --sport 80 --tcp-flags ACK ACK -m string --algo bm --string "src=\"http://1.1.1." -j DROP
```

## 安装ua3f和ShellClash

找到**服务->终端**

```
#从URL安装ShellClash（以下链接三选一）
#GitHub源(可能需要代理)
export url='https://raw.githubusercontent.com/juewuy/ShellCrash/master' && sh -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &> /dev/null
#jsDelivrCDN源
export url='https://fastly.jsdelivr.net/gh/juewuy/ShellCrash@master' && sh -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &> /dev/null
#私人源
export url='https://gh.jwsc.eu.org/master' && sh -c "$(curl -kfsSl $url/install.sh)" && source /etc/profile &> /dev/null
```

![image-20250407180821163](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407180821163.png)

![image-20250407181057614](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407181057614.png)

![image-20250407181136304](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407181136304.png)

![image-20250407181216144](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407181216144.png)

![image-20250407181238614](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407181238614.png)

![image-20250407181250621](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407181250621.png)

![image-20250407181313829](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407181313829.png)

```
#用于UA3F的Clash配置（无外部代理）
https://cdn.jsdelivr.net/gh/SunBK201/UA3F@master/clash/ua3f-cn.yaml
```

![image-20250407181402017](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407181402017.png)

![image-20250407192730832](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407192730832.png)

<img src="https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407192805640.png" alt="image-20250407192805640" style="zoom:80%;" />

<img src="https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407192832533.png" alt="image-20250407192832533" style="zoom:50%;" />

<img src="https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407192912823.png" alt="image-20250407192912823" style="zoom:50%;" />

<img src="https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407192933768.png" alt="image-20250407192933768" style="zoom:50%;" />

<img src="https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407192953799.png" alt="image-20250407192953799" style="zoom:50%;" />

<img src="https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407193025170.png" alt="image-20250407193025170" style="zoom:50%;" />



**启动crash会出现两行报错，下面步骤是问了deepseek解决的**

1. **切换iptables后端的终极方法**

如果系统同时安装了`iptables-legacy`和`iptables-nft`，直接通过符号链接强制指定：

```
# 备份原有命令
mv /usr/sbin/iptables /usr/sbin/iptables.bak
mv /usr/sbin/ip6tables /usr/sbin/ip6tables.bak

# 链接到legacy版本
ln -s /usr/sbin/iptables-legacy /usr/sbin/iptables
ln -s /usr/sbin/ip6tables-legacy /usr/sbin/ip6tables

# 验证版本
iptables --version
```

2. **检查系统日志定位具体错误**

```
# 查看内核日志（重点关注nf_nat相关错误）
dmesg | grep -i "nat\|conntrack\|iptables"

# 查看ShellClash日志
logread | grep "shellclash"
```

3. **测试手动添加PREROUTING规则**

```
# 使用绝对路径强制操作
/usr/sbin/iptables-legacy -t nat -N PREROUTING
/usr/sbin/iptables-legacy -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 7890

# 检查是否生效
iptables-legacy -t nat -L PREROUTING
```

然后再启动`crash -s start`或者crash然后输入1

### 安装UA3F

```
#从URL安装UA3F
opkg update
opkg install curl libcurl luci-compat
export url='https://blog.sunbk201.site/cdn' && sh -c "$(curl -kfsSl $url/install.sh)"
service ua3f reload
```

### 启动UA3F

```
#设置UA3F自动启动
# 启动 UA3F
uci set ua3f.enabled.enabled=1
uci commit ua3f
service ua3f start
```

## 1.配置静态IP（二选一）

如果你觉得方法2太麻烦，可以用这个方法

* 首先重启一下openwrt
* 手机或电脑连接openwrt的wifi，配置静态ip
* 比如：我的lan接口是192.168.1.1
  * IP地址192.168.1.*（\*表示2-254）
  * 网关就是lanIP地址
  * 子网掩码一般都是255.255.255.0
  * dns配一个8.8.8.8就行

这样你就能访问openwrt后台了，然后直接去校园网认证界面，看到导航栏的mac地址是openwrt的地址，然后登录校园网，这样就是openwrt去获取到的校园网ip，在这个openwrt网段下的设备都可以上网。

## 2.安装python3配置认证脚本（二选一）

打开终端

```
opkg update
opkg install python3
opkg install python3-yaml
```

在root目录下创建两个py文件

```
touch ruijie.py
touch config.py
```

下面是ruijie.py代码

```py
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import fcntl  # 文件锁
import subprocess
from datetime import datetime
from json import loads as json_loads
from os.path import dirname, join
from urllib import parse, request
from urllib.request import urlopen

from config import read_cfg

# 配置基础路径
basedir = dirname(__file__) if not getattr(sys, 'frozen', False) else sys._MEIPASS

cfg = read_cfg()

headers = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36',
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    'Cookie': parse.quote(cfg['cookie']),
    'Host': cfg['url']['server'].replace('http://', '').replace('https://', ''),
    'Origin': cfg['url']['server'].replace('http://', '').replace('https://', ''),
}

headers.update(cfg['headers'])

login_data = cfg['login_data']
logout_data = cfg['logout_data']

def notify(title: str, msg: str):
    """命令行输出通知"""
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {title}: {msg}")

def test_internet(host: str = 'http://connect.rom.miui.com/generate_204', timeout: int = 1) -> bool:
    """检测网络连通性（适配OpenWrt）"""
    try:
        # 使用ping检测基础网络
        if subprocess.run(["ping", "-c", "1", "8.8.8.8"], timeout=2).returncode == 0:
            return True
        # 补充HTTP检测
        resp = urlopen(host, timeout=timeout)
        return resp.status == 204 if host.endswith('generate_204') else 200 <= resp.status <= 208
    except Exception:
        return False

def connect():
    """执行登录操作"""
    req = request.Request(
        cfg['url']['server'] + cfg['url']['login'],
        data=parse.urlencode(login_data).encode() if login_data else None,
        headers=headers,
        method='POST'
    )
    try:
        with request.urlopen(req, timeout=10) as res:
            status = json_loads(res.read().decode())
            if status['result'] == 'success':
                notify('联网成功', status.get('message', '网络已连接！'))
            else:
                notify('联网失败', status.get('message', '未知错误'))
    except Exception as e:
        notify('错误', f'连接失败: {str(e)}')
        sys.exit(1)

def disconnect():
    """执行注销操作"""
    req = request.Request(
        cfg['url']['server'] + cfg['url']['logout'],
        data=parse.urlencode(logout_data).encode(),
        headers=headers,
        method='POST'
    )
    try:
        with request.urlopen(req, timeout=10) as res:
            status = json_loads(res.read().decode())
            if status['result'] == 'success':
                notify('断网成功', '已断开网络！')
            else:
                notify('断网失败', status.get('message', '未知错误'))
    except Exception as e:
        notify('错误', f'断网失败: {str(e)}')
        sys.exit(1)

def main():
    # 单实例检测（文件锁）
    lockfile = open('/tmp/ruijie.lock', 'w')
    try:
        fcntl.flock(lockfile, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        notify('警告', '程序已在运行，禁止多开！')
        sys.exit(0)

    # 网络检测逻辑
    if cfg['funtion']['check_school_network']:
        if not subprocess.run(["ping", "-c", "1", "172.31.0.3"], timeout=2).returncode == 0:
            notify('环境检测', '未连接到校园网，程序退出')
            sys.exit(0)

    if test_internet():
        if cfg['funtion']['disconnect_network']:
            disconnect()
        else:
            notify('状态', '网络已连接，无需操作')
    else:
        connect()

if __name__ == '__main__':
    main()
```

找到`"172.31.0.3"`改成你校园网的ip

下面是config.py的代码

```py
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
from os.path import dirname, join
import yaml

current_config_version = 3
config_path = join(dirname(sys.argv[0]), 'config.yml')

def str_value(target: dict):
    """递归转换值为字符串（保持原有逻辑）"""
    for k, v in target.items():
        if isinstance(v, dict):
            str_value(v)
        elif isinstance(v, (int, bool)):  # 处理整型和布尔值
            target[k] = str(v).lower()
        elif v is None:
            target[k] = ''
    return target

def write_config():
    """生成默认配置文件（移除GUI弹窗）"""
    config_template = '''\
# 本配置文件内容需要根据学校服务器设置动态调整
main:
  version: 3 # 配置文件版本号，请勿更改

funtion:
  check_school_network: true
  disconnect_network: true

url:
  server: http://172.31.0.3
  login: /eportal/InterFace.do?method=login
  logout: /eportal/InterFace.do?method=logout

# ...（其他配置项保持原样，此处省略）...
'''
    try:
        with open(config_path, 'w', encoding='utf-8') as fp:
            fp.write(config_template)
        print(f"[INFO] 已生成新配置文件: {config_path}")
    except Exception as e:
        print(f"[ERROR] 配置文件创建失败: {str(e)}")
        sys.exit(1)

def read_cfg() -> dict:
    """读取配置文件（命令行交互版）"""
    # 检查配置文件是否存在
    if not os.path.exists(config_path):
        write_config()
        print("[WARN] 配置文件不存在，已生成模板，请修改后重试！")
        sys.exit(1)

    # 读取配置内容
    try:
        with open(config_path, 'r', encoding='utf-8') as fp:
            cfg = yaml.safe_load(fp)
    except Exception as e:
        print(f"[ERROR] 配置文件读取失败: {str(e)}")
        sys.exit(1)

    # 版本校验
    config_version = cfg['main'].get('version', 0)
    if config_version != current_config_version:
        print(f"[ERROR] 配置文件版本不兼容（当前版本要求：{current_config_version}）")
        sys.exit(1)

    # 数据预处理
    for key in ['url', 'login_data', 'logout_data']:
        if key in cfg and cfg[key] is not None:
            cfg[key] = str_value(cfg[key])

    # 基础校验
    if cfg['login_data'].get('userId') == '00000000000':
        print("[ERROR] 请修改配置文件中的userId字段")
        sys.exit(1)

    # URL格式修正
    if cfg['url']['server'].endswith('/'):
        cfg['url']['server'] = cfg['url']['server'][:-1]

    return cfg
```

然后用命令`python ruijie.py`运行，然后会多出来一个`config.yml`文件

### 配置config.yaml文件

由于我们wifi连接的树莓派，mac地址是树莓派的地址，如果地址栏mac地址是你的电脑，那么你需要修改一下mac地址，然后再进行此操作。断开校园网，用电脑再次认证一遍，认证之前需要打开F12

![image-20250328192042282](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250328192042282.png)

![image-20250328192509309](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250328192509309.png)

![image-20250328192533899](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250328192533899.png)

我打####的地方都需要填，根据上面你获取的信息填

```
# 本配置文件内容需要根据学校服务器设置动态调整
main:
  version: 3 # 配置文件版本号，请勿更改

funtion:
  check_school_network: true # 是否检查校园网环境
  disconnect_network: true # 是否开启断网功能

url:
         #####改成你学校的ip地址
  server: http://172.31.0.3 # 校园网登录服务器的地址，用于判断当前网络环境是否为校园网环境
  login: /eportal/InterFace.do?method=login # 校园网登录地址，无需服务器地址
  logout: /eportal/InterFace.do?method=logout # 校园网断线地址，无需服务器地址

# 请根据抓包结果调整条目与内容
cookie: '##########'

# 请根据抓包结果调整条目与内容（?key1=value1&key2=value2）
# 请不要在密码栏填入明文密码
login_data:
  userId: '##########'
  password: ##########

  service: '#######'
  queryString: #########
  operatorPwd:
  operatorUserId:
  validcode:
  passwordEncrypt: true

# 一般来说不填参数也能用，但请不要删除（?key1=value1&key2=value2）
logout_data: {}

headers:
  Referer: ############


```

把改好的信息填入你的config.yaml<br>退出的校园网，终端运行`python ruijie.py`看看是否能连接成功<br>`http://ua.233996.xyz/`打开这个网站，看看是否被修改成FFF

![image-20250328193913829](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250328193913829.png)

如果没有成功，可以看看是不是ShelClash没有运行,如果运行了，并且网络也能ping通，那么多刷新几遍试试，或者重启一下试试

### 定时断网重连

点开`管控>任务设置>定时执行任务`自定义脚本写下面代码

```
if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then  
       crash -s stop
        sleep 10
        /usr/bin/python3 /root/ruijie.py &  
       sleep 10
       crash -s start
fi 
```

添加一条任务，记得打上对勾，最后面框框是1分钟执行一次，你可以按需更改，最后记得保存

![image-20250406110204329](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250406110204329.png)

## 我遇到过的问题

1. 重启的话网络可能会没有自动连接上，那么就手动连接一下，再启动ShellClash。目前还没有找到100%可以自动启动的方法。

2. 如果你的电脑连接上wifi并且可以上网，其他设备连接上会跳认证界面，你可以找到**网络->接口**把wan口删掉然后创建一个静态的wan口保存一下，然后再删了wan修改回去。然后电脑断掉wifi再连接，基本上就可以了。

3. 有陌生设备连接时会断网，在终端再运行一遍`python ruijie.py`认证一下，目前没有找到更好的办法。

4. 把2做了一遍后手机连接还是跳认证界面，将wifi关掉再打开，或者切换一下网络，然后再重新连接就可以了。

5. 终端不显示，`etc/init.d/ttyd`![image-20250407201653519](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250407201653519.png)

6. 如果你让openwrt用wifi连接的校园网，你再开热点的话，会遇到打不开的情况，输入下面的代码

   ```
   rm /etc/config/wireless
   wifi config
   wifi down
   wifi up
   ```


## 参考

1. https://www.bilibili.com/video/BV1yr4meeENt/?spm_id_from=333.1391.0.0
2. https://www.bilibili.com/video/BV1qM411w7W5/?spm_id_from=333.1391.0.0&vd_source=bde3073c7fac1db05c5ea47eed6aa6a6
3. https://github.com/IDeLoveYou/SGU-Script认证脚本是在这个作者代码的基础上更改的

## 吐槽

这玩意折磨了我两个星期，太难受了，走了好多弯路🥲
