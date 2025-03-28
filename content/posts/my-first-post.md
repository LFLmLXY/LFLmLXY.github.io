---
title: '这是一篇测试文章'
date: 2025-03-02T11:01:38+08:00
categories: ["通用技术"]
draft: true # 是否为草稿
tags: ["博客搭建", "Bilibili"]
draft: true # 是否为草稿
author: ["LFL"] 
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

## 前言

这是一篇介绍如何使用 Hugo + PaperMod + Github Pages 搭建一个完善的个人博客的教程。


```css
.post-content pre,
code {
  font-family: "JetBrains Mono", monospace;
  font-size: 1rem;
  line-height: 1.2;
}
```
```c++
#include <iostream>
#include <string.h>
#include <conio.h>
#include <windows.h>
#include <graphics.h>
#include <string>
#include <ctime>
#include "game1.h"
#include "game2.h"

using namespace std;

#define MAX 10

/*
新增，修改（全部读取出来，然后进行覆盖需要修改的文件覆盖成新的内容），删除同修改
*/

typedef struct label
{
    int x;
    int y;
    int width;
    int height;
    char text;
    bool isEnable; // 标记是否被改变
} Label;

bool W_start = false;   // 起始点是否存在
bool W_end = false;     // 终止点是否存在
label LabelSave;        // 保存按钮
label LabelNext;        // 下一个按钮
label Labeldel;         // 删除按钮
label LabelAgame;       // 游戏按钮
label Labelgame;        // 游戏按钮
Label labels[MAX][MAX]; // 迷宫图的标签
label LabelNum;         // 迷宫图的编号
label LabelTime1;       // 游戏时长增加
label LabelTime2;       // 游戏时长减少
label LabelTime_Tip;    // 游戏时长提示
label LabelHelp_Tip;    // 游戏帮助提示
HWND hwnd;              // 窗口句柄

int help_flag = 0;      // 帮助标志
int game_Time_Tip = 60; // 游戏时长变量
int BH_next = 1;        // 迷宫图的索引
   
```

或许也可以让 chatgpt 的访问更加丝滑。

起因是在看 react 的官方教程时，发现有一张图片无法访问，对，就是下面这张，

![](https://i.imgur.com/yXOvdOSs.jpg)

其实我最近两年的 imgur 的访问一直比较有问题，有时候需要换很多个节点才能尝试出来一个可以正常加载 imgur 图片的 ip，而有时候甚至会全军覆没。

今天实在忍不了了，所以，就在网上找了一下有没有好的方法可以实现 imgur 的图片的正常访问，因为这个图床(图片托管网站)用到的地方挺多的，比如，像上面的 reactjs 的官网都会用到，还有 v 站也是默认会渲染 imgur 的图片，我自己的博客之前也是用 imgur 比较多，现在则换成了访问更加顺畅的 postimage，不过，我还有很多图片没有迁移过去，所以，解决 imgur 这个图床的问题迫在眉睫。找了一圈，发现还是用 warp 套一层比较合适。

那么，具体是怎么操作呢？

![](https://img.shetu66.com/2023/04/25/1682391086456995.png)