---
title: "Hugo + PaperMod + Github Pages 搭建一个完善的个人博客"
date: 2025-03-03T21:45:43+08:00
lastmod: 2025-03-03T21:45:43+08:00
draft: true # 是否为草稿
author: ["tkk"]

categories: ["其他"]

tags: ["博客搭建"]

keywords: []

description: "" # 文章描述，与搜索优化相关
summary: "" # 文章简单描述，会展示在主页
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
comments: false
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

## 下载 hugo
首先，安装 hugo，在 Windows 中，推荐使用 scoop 来安装预编译的二进制版本
```
scoop install hugo-extended
```
如果缺少scoop的话跟着下面来安装，如何上面代码没有出错请跳过'安装scoop'这一步
### 安装 scoop
确保以允许 Powershell 执行本地脚本
```
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
```
输入以下命令安装scoop
```
iwr -useb get.scoop.sh | iex
```
安装完成后，输入`scoop`命令查看是否安装成功<br>然后安装hugo,安装完之后·输入`hugo version`命令查看版本号

![image-20250304190914451](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250304190914451.png)

这样就表示安装成功了！！<br>

## 建立站点

在本地使用hugo创建一个站点`hugo new site <文件夹名>`

```
hugo new site dev
```

然后，

```
cd dev
```

## 添加 PaperMod 主题

然后，我们先将此目录初始化成 git 仓库

```
git init
git add .
git commit -m "first commit"
```

输入,**记得开魔法**

```
git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

可以看一下这个目录会增加很多文件

![image-20250304193251123](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250304193251123.png)

在`dev/`目录下创建一个`.gitignore`文件,这个文件的作用是为了上传github时候过滤掉不需要的文件<br>文件中添加下面数据

```
public
resources
.hugo_build.lock
hugo.exe
```

## 配置 PaperMod 主题

把在`dev/`下的hugo.toml 改成hugo.yaml

```
Rename-Item .\hugo.toml hugo.yaml
```

然后，配置一下基本信息

```
baseURL: "https://LFLmLXY.github.io" # 主站的 URL
title: LFL's Blog # 站点标题
copyright: "[©2025 LFL's Blog](https://LFLmLXY.github.io/)" # 网站的版权声明，通常显示在页脚
theme: PaperMod # 主题
languageCode: zh-cn # 语言

enableInlineShortcodes: true # shortcode，类似于模板变量，可以在写 markdown 的时候便捷地插入，官方文档中有一个视频讲的很通俗
hasCJKLanguage: true # 是否有 CJK 的字符
enableRobotsTXT: true # 允许生成 robots.txt
buildDrafts: false # 构建时是否包括草稿
buildFuture: false # 构建未来发布的内容
buildExpired: false # 构建过期的内容
enableEmoji: true # 允许 emoji
pygmentsUseClasses: true
defaultContentLanguage: zh # 顶部首先展示的语言界面
defaultContentLanguageInSubdir: false # 是否要在地址栏加上默认的语言代码

#配置导航栏
languages:
  zh:
    languageName: "中文" # 展示的语言名
    weight: 1 # 权重
    taxonomies: # 分类系统
      category: categories
      tag: tags
    # https://gohugo.io/content-management/menus/#define-in-site-configuration
    menus:
      main:
        - name: 首页
          pageRef: /
          weight: 1 # 控制在页面上展示的前后顺序
       # - name: 文章
       #   pageRef: posts/
       #   weight: 2
        - name: 归档
          pageRef: archives/
          weight: 5
        - name: 分类
          pageRef: categories/
          weight: 10
        - name: 标签
          pageRef: tags/
          weight: 10
        - name: 搜索
          pageRef: search/
          weight: 20
        - name: 关于
          pageRef: about/
          weight: 21

```

