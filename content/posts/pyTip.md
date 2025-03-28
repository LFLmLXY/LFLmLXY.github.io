---
title: "积累算法题🎋"
date: 2025-03-11T20:18:54+08:00
lastmod: 2025-03-11T20:18:54+08:00
draft: false # 是否为草稿
author: ["LFL"] 

categories: ["编程语言"]

tags: ["Python"]

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

## 1. 最大公约数

```py
"""
输入两个正整数求它们的最大公约数
"""
x = int(input('x = '))
y = int(input('y = '))
s = x * y
while y % x != 0:
    x, y = y % x, x
print(f'最大公约数: {x}')
print(f'最小公倍数: {s/x}')
```

---

## 2.斐波那契数列

```py
"""
输出斐波那契数列中的前20个数
"""
a, b = 0, 1
for _ in range(20):
    a, b = b, a + b
    print(a)
```

## 3. 快速幂

![image-20250312234629339](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250312234629339.png)

如图所示，如果幂是奇数就减1算的时候乘自变量，是偶数就除2算的时候乘自身。一共有三个自身和一个自变量<br>计算的时候一定是从下往上的。<br>例如：<br>![image-20250312235536727](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250312235536727.png)
