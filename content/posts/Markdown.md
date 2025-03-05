---
title: 'Markdown 语法参考手册'
date: 2025-03-03T21:45:38+08:00
categories: ["手册"]
tags: ["Markdown"]
author: ["LFL"]
---
<meta name="referrer" content="no-referrer" />

# Markdown 基本语法

## 标题(Headings)

- `# 一级标题` 渲染为 `<h1>一级标题</h1>`

- `## 二级标题` 渲染为 `<h2>二级标题</h2>`

- `### 三级标题` 渲染为 `<h3>三级标题</h3>`

- `#### 四级标题` 渲染为 `<h4>四级标题</h4>`

- `##### 五级标题` 渲染为 `<h5>五级标题</h5>`

- `###### 六级标题` 渲染为 `<h6>六级标题</h6>`

  

## 段落 (Paragraphs)

Markdown 语法中的段落由一个或多个文本行组成，**使用空行来分隔不同的段落**。``

这是第一段。

这是第二段。

## 换行 (Line Breaks)

`文字<br>`<br>我是第一行<br>我是第二行   

## 粗体 (Bold)

Markdown 语法支持两种强调方式：使用 **两个星号 (**) 或 **两个下划线 (__)** 将文本括起来。

`**粗体文本**` 或 `__粗体文本__` 渲染为 `<strong>粗体文本</strong>`。

**这是粗体文本**

__这也是粗体文本__

不需要增加额外的空格

## 引用 (Blockquotes)

在段落前添加 **>** 符号来创建引用`>例如`

> 这是引用的内容

嵌套引用`>>文字`

> 这是一级
>
> > 这是二级
> >
> > > 这是三级

## 列表 (Lists)

- ### 有序列表 (Ordered Lists)

  使用 **数字加英文句点** `.` 来创建有序列表

  1. 第一项
  2. 第二项

- ### 无序列表 (Unordered Lists)

​	使用 **减号** `-`、**星号** `*` 或 **加号** `+` 来创建无序列表。

- ### 嵌套列表 (Nested Lists)

  1. 第一项

     1. 嵌套第一项的第一项

     2. 嵌套第一项的第二项

  2. 第二项

     - 这是第一项
        - 这是二一一
          + 这是二一一一

  - 这是第三项
    - 这是三一
      - 这是三一一

## 代码 (Code)

- ### 行内代码 (Code Spans)

​	使用 **反引号** \` 包裹行内代码。`include <stdio.h>`

​	如果代码内包含\`可以使用**双反引号 (``)** 

- ### 代码块 (Code Blocks)

  **围栏式代码块**：使用 **三个反引号** ```

  ```py
  def hello():
      print("Hello, world!")
  ```

## 分割线 (Horizontal Rules)

Markdown 语法使用 **三个或更多星号** `***`、**减号** `---` 或 **下划线** `___` 来创建水平分割线。和`<hr />`相同

----

## 链接 (Links)

使用 **方括号** `[]` 包裹链接文本，紧接着使用 **圆括号** `()` 包裹 URL 链接地址。

[链接文本](https://www.example.com)

还可以在 URL 后面的圆括号中添加**链接标题**。悬浮会有提示`[链接文本](https://www.example.com "链接标题")`

[请把鼠标放在我身上](https://www.example.com "我是悬浮文本")

可以使用 **尖括号** `<>` 来快速将 URL 或邮箱地址转换为链接。`<https://www.baidu.com>`

<https://www.baidu.com>

## 图片 (Images)

其实与链接相同，只是后面的链接是图片地址链接

![OIP-C](https://gitee.com/a-cake-tree/typora-image/raw/master/OIP-C.jpeg)

![ABC](https://gitee.com/a-cake-tree/typora-image/raw/master/ABC.jpeg)
