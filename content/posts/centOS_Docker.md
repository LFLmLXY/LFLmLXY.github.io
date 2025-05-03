---
title: "Docker的安装与配置"
date: 2025-05-03T16:47:54+08:00
lastmod: 2025-05-03T16:47:54+08:00
draft: false # 是否为草稿
author: ["LFL"] #文章作者

categories: ["计算机"] #文章分类

tags: ["docker"] #文章标签

keywords: []

description: "" # 文章描述，与搜索优化相关
summary: "" # 文章简单描述，会展示在主页
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
comments: true # 是否启用评论系统
autoNumbering: true # 目录自动编号
hideMeta: false # 是否隐藏文章的元信息，如发布日期、作者等
mermaid: true
cover: #帖子封面图片
    image: ""
    caption: ""
    alt: ""
    relative: false
---

<meta name="referrer" content="no-referrer" />

# 一、 前言

写这篇文章的原因是我不想在本机上安装别的版本的`mysql`和`redis`，但我想使用，于是我用`vm`装了`CentOS7`，安装了`docker`，部署了`mysql`和`redis`。

## 环境

|     名称     |       介绍        |
| :----------: | :---------------: |
| 安装软件名称 | Docker 版本26.1.4 |
| 操作命令对象 | Docker 版本26.1.4 |
| 远程操作系统 |  CentOS 7.9 64位  |
| 远程管理工具 | FinalShell 4.5.12 |
| 安装软件名称 |  MySQL 版本8.3.0  |

# 二、配置YUM

> 报错`Could not retrieve mirrorlist http://mirrorlist.centos.org/?release=7&arch= `
>
> 原因：CentOS7仓库已经被归档，当前的镜像地址无法找到所需的文件
>
> [详细信息查看](https://www.cnblogs.com/kohler21/p/18331060)

## 解决方法

进入`/etc/yum.repos.d`目录下找到 `CentOS-Base.repo`<br>进入目录：

```bash
cd /etc/yum.repos.d
```

依次执行：

```bash
cp  CentOS-Base.repo   CentOS-Base.repo.backup
vi CentOS-Base.repo
```

进入后改为：

```bash
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the 
# remarked out baseurl= line instead.
#
#
 
[base]
name=CentOS-$releasever - Base
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
#baseurl=http://vault.centos.org/7.9.2009/x86_64/os/
baseurl=http://vault.centos.org/7.9.2009/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
 
#released updates 
[updates]
name=CentOS-$releasever - Updates
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/updates/$basearch/
#baseurl=http://vault.centos.org/7.9.2009/x86_64/os/
baseurl=http://vault.centos.org/7.9.2009/updates/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
 
#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra
#$baseurl=http://mirror.centos.org/centos/$releasever/extras/$basearch/
#baseurl=http://vault.centos.org/7.9.2009/x86_64/os/
baseurl=http://vault.centos.org/7.9.2009/extras/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
 
#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus&infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/centosplus/$basearch/
#baseurl=http://vault.centos.org/7.9.2009/x86_64/os/
baseurl=http://vault.centos.org/7.9.2009/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```

然后保存，依次执行：

```bash
sudo yum clean all
sudo yum makecache
```

## 阿里云镜像源

执行完成后进入/etc/yum.repos.d

```bash
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
```

然后执行：

```bash
 cat CentOS-Base.repo
```

看着镜像是阿里云的即可。 建议在执行：

```bash
sudo yum clean all
sudo yum makecache
```

# 三、安装Docker及MySQL

> Docker安装：[详细参考](https://blog.csdn.net/Aaaaaaatwl/article/details/139860522)
>
> MySQL安装：[详细参考](https://blog.csdn.net/donkor_/article/details/139879575)
>
> 镜像源：[详细参考](https://www.kelen.cc/dry/docker-hub-mirror)
>
> Docker镜像仓库：[地址](https://hub.docker.com/)

## 1. 卸载Docker

查看docker是否存在

```bash
docker --version
```

卸载

```bash
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine \
                  docker-ce
```

如果在卸载过程中遇到端口占用可以杀死端口

```bash
kill [options] <pid>
例如：
kill -9 8080
```

## 2. 安装Docker

更新你的包列表：

```bash
sudo yum update
```

**若：没有yum命令，安装yum,有的话直接跳过**

```bash
yum install -y yum-utils \
           device-mapper-persistent-data \
           lvm2 --skip-broken
```

安装必要的包，这些包可以让yum使用HTTPS：

```bash
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

添加Docker的存储库：

```bash
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

**如果失败试一下下面这个命令,未失败直接进行下一步**

```bash
# 设置docker镜像源
yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    
sed -i 's/download.docker.com/mirrors.aliyun.com\/docker-ce/g' /etc/yum.repos.d/docker-ce.repo

yum makecache fast
```

安装Docker：

```bash
sudo yum install docker-ce
```

启动Docker服务：

```bash
sudo systemctl start docker
```

验证Docker是否安装成功：

```bash
sudo docker pull hello-world
```

启动docker失败，关闭防火墙重试

```bash
# 关闭
systemctl stop firewalld
# 禁止开机启动防火墙
systemctl disable firewalld
#查看是否关闭防火墙
systemctl status firewalld
```

查看Docker运行状态：

```bash
systemctl status docker
```

查看 hello-world 镜像是否存在

```
sudo docker images
```

如果不存在，可能是需要配置一下镜像源

```bash
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://p4220st1.mirror.aliyuncs.com",
        "https://docker.xuanyuan.me",
        "https://docker.1ms.run",
        "https://docker.sunzishaokao.com",
        "https://docker.1panel.live",
        "https://hub.rat.dev",
        "https://docker.wanpeng.top",
        "https://doublezonline.cloud"
        ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 3. 安装MySQL

### 查找MySQL镜像

```bash
docker search mysql
```

### 拉取MySQL镜像

```bash
docker pull mysql:8.3.0
```

### 查看MySQL镜像

```bash
docker images mysql:8.3.0
```

### 创建挂载目录

后面用于挂载`mysql容器`内目录，这里就放在home目录下

```bash
mkdir -p  /home/mysql/{conf,data,log}
```

### 创建配置文件

```bash
cd /home/mysql/conf
vi my.cnf
```

添加下面代码

```bash
[client]
#设置客户端默认字符集utf8mb4
default-character-set=utf8mb4
[mysql]
#设置服务器默认字符集为utf8mb4
default-character-set=utf8mb4
[mysqld]
#配置服务器的服务号，具备日后需要集群做准备
server-id = 1
#开启MySQL数据库的二进制日志，用于记录用户对数据库的操作SQL语句，具备日后需要集群做准备
log-bin=mysql-bin
#设置清理超过30天的日志，以免日志堆积造过多成服务器内存爆满。2592000秒等于30天的秒数
binlog_expire_logs_seconds = 2592000
#解决MySQL8.0版本GROUP BY问题
sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'
#允许最大的连接数
max_connections=1000
# 禁用符号链接以防止各种安全风险
symbolic-links=0
# 设置东八区时区
default-time_zone = '+8:00'
```

## 4. 启动MySQL容器

-p表示端口映射
--restart=always表示容器退出时总是重启
--name表示容器命名
--privileged=true表示赋予容器权限修改宿主文件权利
-v /home/mysql/log:/var/log/mysql表示容器日志挂载到宿主机
-v /home/mysql/data:/var/lib/mysql表示容器存储文件挂载到宿主机
-v /home/mysql/conf/my.cnf:/etc/mysql/my.cnf表示容器配置文件挂载到宿主机
-e MYSQL_ROOT_PASSWORD=a12bCd3_W45pUq6表示设置mysql的root用户密码,建议用强密码
-d表示后台运行

```bash
docker run \
-p 3306:3306 \
--restart=always \
--name mysql \
--privileged=true \
-v /home/mysql/log:/var/log/mysql \
-v /home/mysql/data:/var/lib/mysql \
-v /home/mysql/conf/my.cnf:/etc/mysql/my.cnf \
-e MYSQL_ROOT_PASSWORD=a12bCd3_W45pUq6 \
-d mysql:8.3.0  
```

<hr>

快去使用你的数据库软件连接一下吧！！！
