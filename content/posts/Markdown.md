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

Markdown 语法中的段落由一个或多个文本行组成，**使用空行来分隔不同的段落**。

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


## 代码 (Code)

- ### 行内代码 (Code Spans)

  ```markdown
  `include <stdio.h>`
  ```

​	`include <stdio.h>`

- ### 代码块 (Code Blocks)

  ````markdown
  ```python
  def hello():
      print("Hello, world!")
  ```
  ````
  
  
  
  ```markdown
  def hello():
      print("Hello, world!")
  ```

## 分割线 (Horizontal Rules)

Markdown 语法使用 **三个或更多星号** `***`、**减号** `---` 或 **下划线** `___` 来创建水平分割线。和`<hr />`相同

----

## 链接 (Links)

```markdown
[链接文本](https://www.example.com)
```

[链接文本](https://www.example.com)

``` markdown
[请把鼠标放在我身上](https://www.example.com "我是悬浮文本")
```

[请把鼠标放在我身上](https://www.example.com "我是悬浮文本")

```markdown
<https://www.baidu.com>
```

<https://www.baidu.com>

## 图片 (Images)

```markdown
![OIP-C](https://gitee.com/a-cake-tree/typora-image/raw/master/OIP-C.jpeg)
```

![OIP-C](https://gitee.com/a-cake-tree/typora-image/raw/master/OIP-C.jpeg)

## 表格

```markdown
| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |
```

| First Header | Second Header |
| ------------ | ------------- |
| Content Cell | Content Cell  |
| Content Cell | Content Cell  |

## 任务列表

```markdown
- [ ] a task list item
- [X] a task list item
```

- [ ] a task list item

- [X] a task list item

## 分割线

```markdown
***
---
```

---

***

## 警示块

```markdown
> [!NOTE]
> 突出显示用户应考虑的信息，即使只是浏览也应考虑。

> [!TIP]
> 可选信息，可帮助用户取得更大的成功。

> [!IMPORTANT]
> 用户成功所需的关键信息。

> [!WARNING]
> 由于存在潜在风险，需要用户立即关注的关键内容。

> [!CAUTION]
> 操作的潜在负面后果。
```

> [!NOTE]
> 突出显示用户应考虑的信息，即使只是浏览也应考虑。

> [!TIP]
> 可选信息，可帮助用户取得更大的成功。

> [!IMPORTANT]
> 用户成功所需的关键信息。

> [!WARNING]
> 由于存在潜在风险，需要用户立即关注的关键内容。

> [!CAUTION]
> 操作的潜在负面后果。

```markdown
> [!NOTE] FixIt
```

> [!NOTE] 



> [!WARNING]+ 辐射

