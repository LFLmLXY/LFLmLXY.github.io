---
title: "数字签名简述"
date: 2025-12-06T22:09:39+08:00
lastmod: 2025-12-06T22:09:39+08:00
draft: false # 是否为草稿
author: ["LFL"] #文章作者

categories: ['网络'] #文章分类

tags: [] #文章标签

keywords: []

description: "数字签名" # 文章描述，与搜索优化相关
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


## 一、介绍

百科：是一种功能类似写在纸上的普通签名、但是使用了[公钥加密](https://zh.wikipedia.org/wiki/公钥加密)领域的技术，以用于鉴别数字信息的方法。一套数字签名通常会定义两种互补的运算，一个用于签名，另一个用于验证。

数字签名的出现是为了解决，将公钥安全的传送到目标。防止黑客截获篡改公钥。

## 二、原理

签名：网站提供<b>数据或密钥</b>给CA组织，将其用散列函数进行转码，再给转码后的值用CA的私钥加密。

验证：使用CA的公钥解密，再将传过来的<b>数据或密钥</b>用相同的散列函数转码，最后两者进行比较是否一样。

![Digital_Signature_diagram_zh-CN.svg](https://gitee.com/a-cake-tree/typora-image/raw/master/Digital_Signature_diagram_zh-CN.svg.png)

## 三、扩展

为了证明数字证书是CA，需要使用根CA对中间CA进行数字签名，那谁给根CA签名呢？答案是它自己

![数字证书流程图](https://gitee.com/a-cake-tree/typora-image/raw/master/数字证书流程图.png)

根证书一般是电脑的操作系统或出厂自带的，一般都是可信的，所以自签名是不验证的

公钥->私钥 | 加密->解密。私钥->公钥 | 签名->验证
