---
title: "MC服务器搭建"
date: 2025-04-05T14:31:51+08:00
lastmod: 2025-04-05T14:31:51+08:00
draft: false# 是否为草稿
author: ["LFL"] #文章作者

categories: ["游戏","部署","服务器"] #文章分类

tags: ["MC_Server","centOS"] #文章标签

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

## 最低jdk版本要求

先贴一个来自Minecraft Wiki的Minecraft对Java的[运行标准](https://zh.minecraft.wiki/w/Java%E7%89%88)

从1.12（17w13a）开始，运行Minecraft的最低要求是**jdk8**。

从1.17（21w19a）开始，运行Minecraft的最低要求是**jdk16**。

从1.18（1.18-pre2）开始，运行Minecraft的最低要求是**jdk17**。

从1.20.5（24w14a）开始，运行Minecraft的最低要求是**jdk21**，且操作系统要求为**64位**。

jdk版本[下载地址](https://www.oracle.com/java/technologies/downloads/?er=221886)

解压和安装

```bash
tar -zxvf jdk-17.0.14_linux-x64_bin.tar.gz
mv jdk-17.0.14 /usr/local/java/
alternatives --install /usr/bin/java java /usr/local/java/jdk-17.0.14/bin/java 3
```

alternatives安装和移除命令参数（看看就行）：

```bash
alternatives --install <link> <name> <path> <priority>
alternatives --remove <name> <path>
```

切换jdk版本

```bash
alternatives --config java
```

注意：添加两个及以上的版本时需要给`/etc/profile`文件末尾加上

```bash
export JAVA_HOME=/usr/local/java/jdk1.8.0_311
export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
export PATH=$PATH:${JAVA_HOME}/bin
```

```bash
source /etc/profile
```



要不然切换不了低版本不知道为什么

## mc原版下载

原版的[下载地址](https://mcversions.net/)。然后将下载的jar文件上传至你的服务器的某个文件夹下，然后使用`cd`命令进入该文件夹（一定要使用`cd`命令进入！）

我下载文件为`server.jar`，上传并`cd`进所在文件夹之后执行命令启动服务端：

```bash
java -jar server.jar nogui
```

也可以加上jvm参数限制运行内存：

```bash
# 限制最小内存为256MB，最大内存为1024MB
java -Xms256M -Xmx1024M -jar server.jar nogui
```

第一次启动会失败，因为需要你同意一下EULA协议，刷新目录可见当前目录生成了个`eula.txt`把里面的`false`改成`true`然后保存，再重新启动一遍

显示 *done!* 字样说明启动成功：![image-20250406162618811](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250406162618811.png)

不过因为是第一次启动，我们仍然需要修改一些配置才能玩，所以先输入`stop`停止服务端。<br>刷新目录，发现已经生成了很多文件，找到`server.properties`文件，这个是服务端配置文件，我们需要进行一些修改，里面内容如下：<br>![image-20250406162827347](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250406162827347.png)

上面的`online-mode`一定要改为`false`否则非正版玩家无法进入。<br>其余根据实际情况配置，端口的话即可也要配置一下服务器防火墙开放对应端口，默认端口就是`25565`。

再次执行启动命令：

```bash
java -jar server.jar nogui
```

等待启动完成即可！<br>然后打开游戏->多人游戏->添加服务器（或者直接连接），地址填：`你的服务器外网地址:服务器端口`<br>然后就可以进入游戏了！

## 安装 Forge

去[Forge官网](https://files.minecraftforge.net/net/minecraftforge/forge/?spm=a2c6h.12873639.article-detail.8.5e0f292378Ap4E)下载你想要的版本的Forge，下载installer版<br>小细节：这里要复制一下连接，把前面的https链接删掉，用后面的https链接

![image-20250406172410630](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250406172410630.png)

得到一个jar文件，将其上传至服务器某个目录下，并使用`cd`命令进入该目录，执行安装命令：

```bash
java -jar "文件名" --installServer
```

然后它就开始下载相应的依赖库，需要等一会，因为是从外网下载因此可能很慢或者失败，可以多试几次。<br>如果一直下载不成功且你有代理的话，可以在执行Forge Installer时通过jvm参数指定代理：

```bash
# 例如：java -Dhttp.proxyHost="127.0.0.1" -Dhttp.proxyPort="1080" -Dhttps.proxyHost="127.0.0.1" -Dhttps.proxyPort="1080" -jar "forge-1.12.2-14.23.5.2855-installer.jar" --installServer
java -Dhttp.proxyHost="http代理地址" -Dhttp.proxyPort="http代理端口" -Dhttps.proxyHost="https代理地址" -Dhttps.proxyPort="https代理端口" -jar "forge installer文件" --installServer
```

最后出现`successfully`字样则成功<br>刷新目录，我们发现会多出一个文件名形如`forge-x.x.xx-xxx.jar`的文件，这个就是主要的forge服务端文件，待会需要执行它启动。（如果是1.7.10版本或者低版本的forge那么这个主服务端文件名应该是`forge-x.x.xx-xxx-universal.jar`的形式）：

![image-20250406173124300](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250406173124300.png)

**有的版本不会出现`forge-x.x.xx-xxx.jar`但会出现`run.sh`使用下面操作启动**

```bash
./run.sh
```

我们可以先删除installer的jar文件和log，因为用不着了<br>然后使用命令启动forge服务端，例如我这个版本的：

```bash
java -jar "forge-1.21.5-55.0.0-shim.jar" nogui
```

到这里如果你是先下载的原版mc在下载的forge，显示done！那么就可以直接玩了。刷新目录会有一个mods文件夹，里面可以放mod。下次再启动就运行上面的代码即可

![image-20250406173623847](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250406173623847.png)

不过有一个问题，**当我们关闭FinalShell远程窗口会话之后，服务端也跟着终止了**。

## 安装 Screen

`screen`可以让进程在后台运行

```bash
yum update
yum install screen
```

`screen`常用命令介绍

```bash
# 创建一个新的窗口
screen -S test
 
# 进入窗口后 执行文件
python test.py
 
# 退出当前窗口
ctrl+a+d   （方法1：保留当前窗口）
screen -d  （方法2：保留当前窗口）
exit       （方法3：退出程序，并关闭窗口）
 
# 查看窗口
screen -ls
 
# 重新连接窗口
screen -r id或窗口名称
 
# 示例：
screen -r 344 
screen -r test
```

## 权限问题

只想给玩家tp权限，我们可以借助`LuckPerms`插件

### 原版

下载[PaperMC](https://papermc.io/downloads)+[LuckPerms](https://luckperms.net/download)

LuckPerms版本：Bukkit、Sponge

LuckPerms放入位置：plugins

### Forge版

下载[LuckPerms](https://luckperms.net/download)

LuckPerms版本：Forge

LuckPerms放入位置：mods

### 设置权限

输入以下命令，禁止默认组使用所有原版命令：

```bash
/lp group default permission set minecraft.command.* false
```

单独开启 `/tp` 权限

```bash
/lp group default permission set minecraft.command.teleport true
```

保存并重载权限

输入命令使更改生效：

```bash
/lp sync
```

## 其他常用指令

```bash
gamerule keepInventory true    #死亡不掉落
```
