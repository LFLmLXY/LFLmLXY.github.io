---
title: "为Tailscale添加中转服务器drep"
date: 2025-04-01T18:42:24+08:00
lastmod: 2025-04-01T18:42:24+08:00
draft: true # 是否为草稿
author: ["LFL"] #文章作者

categories: ["服务器"] #文章分类

tags: ["drep","Tailscale"] #文章标签

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

## 简介

目的：记录一下配置中转服务器

原因：tailscale在国内没有中转服务器，使用的话延迟会很高

服务器：用的华为云，系统是centos 8

## 安装go语言

先更新软件包列表，然后升级已安装的软件包

```bash
apt update && apt upgrade
```

安装所需的软件，包括wget、git、openssl、curl

```
apt install -y wget git openssl curl
```

安装go语言，建议**安装最新版go**

```
wget https://go.dev/dl/最新版包名
```

去这里看最新版包名[go官方的安装手册](https://golang.google.cn/doc/install)，或者本地下载，上传到服务器

删除旧go解压新go

```
rm -rf /usr/local/go && tar -C /usr/local -xzf 最新版包名
```

添加环境变量

```
echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
source /etc/profile
```

## 配置Derp

找到目录`/root/go/pkg/mod/tailscale.com@xxxxxxxxxxx/cmd/derper`下的`cert.go`修改成如下所示，**有可能版本不同代码不会一模一样**<br>这是验证域名的，因为我们是没有域名，所以这个地方注释掉，不要去校验

```go
func (m *manualCertManager) getCertificate(hi *tls.ClientHelloInfo) (*tls.Certificate, error) {
	//if hi.ServerName != m.hostname && !m.noHostname {
	//	return nil, fmt.Errorf("cert mismatch with hostname: %q", hi.ServerName)
	//}
```

然后

```
cd /root/go/pkg/mod/tailscale.com@xxxxxxxxxxx/cmd/derper
```

编译

```
go build -o /etc/derp/derper
```

回到`root`目录，执行代码，查看是否多了一个derper文件

```
ls /etc/derp
```

自签一个域名给Derp

`derp.myself.com`可以自定义

```
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout /etc/derp/derp.myself.com.key -out /etc/derp/derp.myself.com.crt -subj "/CN=derp.myself.com" -addext "subjectAltName=DNS:derp.myself.com"
```

将derp变成服务

```
cat > /etc/systemd/system/derp.service <<EOF
[Unit]                                                                      Description=TS Derper
After=network.target
Wants=network.target
[Service]
User=root
Restart=always
ExecStart=/etc/derp/derper -hostname derp.myself.com -a :33445 -http-port 33446 -certmode manual -certdir /etc/derp
RestartPreventExitStatus=1
[Install]
WantedBy=multi-user.target
EOF

```

**把服务器的tcp的33445（HTTPS需要）和udp的3478（STUN需要）的端口打开**

设置开机自启动，开启服务

```
systemctl enable derp
systemctl start derp
```

验证Derp是否启动<br>在浏览器输入`https://服务器公网ip:33445/`，出现DERP界面就表示成功了

## 参考

1. https://blog.csdn.net/u010263423/article/details/143858848
2. https://www.bilibili.com/video/BV1Wh411A73b/?spm_id_from=333.1007.top_right_bar_window_history.content.click











