---
title: "Hugo + PaperMod + Github Pages 搭建一个完善的个人博客"
date: 2025-03-03T21:45:43+08:00
lastmod: 2025-03-05T21:33:10+08:00
draft: false # 是否为草稿
author: ["LFL"]

categories: ["搭建博客"]

tags: ["hugo"]

keywords: []

description: "" # 文章描述，与搜索优化相关
summary: "" # 文章简单描述，会展示在主页
weight: # 输入1可以顶置文章，用来给文章展示排序，不填就默认按时间排序
slug: ""
comments: true  # 是否启用评论系统
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

## 1. 前言

写这篇文章为了熟悉一下markdown的语法，如果以后还要建blog的话可以有一个熟悉的参考。<br>我是跟随着这位[大佬](https://sonnycalcr.github.io/)建好的博客，这篇文章也是参考大佬的博客写的。<br>[bilibili](https://www.bilibili.com/video/BV1pRYPetEWy/?spm_id_from=333.1007.top_right_bar_window_history.content.click)这是他建博客的视频，你们哪里不懂的可以看一下。

## 2. 搭建 hugo

首先，安装 hugo，在 Windows 中，推荐使用 scoop 来安装预编译的二进制版本
```powershell
scoop install hugo-extended
```
如果缺少scoop的话跟着下面来安装，如何上面代码没有出错请跳过'安装scoop'这一步
### 安装 scoop
确保以允许 Powershell 执行本地脚本
```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
```
输入以下命令安装scoop
```powershell
iwr -useb get.scoop.sh | iex
```
安装完成后，输入`scoop`命令查看是否安装成功<br>然后安装hugo,安装完之后·输入`hugo version`命令查看版本号

![image-20250304190914451](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250304190914451.png)

这样就表示安装成功了！！<br>

### 建立站点

在本地使用hugo创建一个站点`hugo new site <文件夹名>`

```powershell
hugo new site dev
```

然后，

```powershell
cd dev
```

## 3.  配置PaperMod 

然后，我们先将此目录初始化成 git 仓库

```powershell
git init
git add .
git commit -m "first commit"
```

输入,**记得开魔法**

```powershell
git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

可以看一下这个目录会增加很多文件

![image-20250304193251123](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250304193251123.png)

在`dev`目录下创建一个`.gitignore`文件,这个文件的作用是为了上传github时候过滤掉不需要的文件<br>文件中添加下面数据

```powershell
public
resources
.hugo_build.lock
hugo.exe
```

### 配置主题

把在`dev`下的hugo.toml 改成hugo.yaml

```powershell
Rename-Item .\hugo.toml hugo.yaml
```

然后，配置一下基本信息

```yaml
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
pagination.pagerSize: 5 #5篇文章翻页
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
params:
  env: production # to enable google analytics, opengraph, twitter-cards and schema.
  title: ExampleSite
  description: "ExampleSite description"
  keywords: [Blog, Portfolio, PaperMod]
  author: Me
  # author: ["Me", "You"] # multiple authors
  images: ["<link or path of image for opengraph, twitter-cards>"]
  DateFormat: "January 2, 2006"
  # 默认主题
  defaultTheme: auto # dark, light
  # 是否禁用主题切换按钮
  disableThemeToggle: false

  # 是否启用阅读时间展示
  ShowReadingTime: true
  # 是都启用分享按钮
  ShowShareButtons: true
  ShowPostNavLinks: true
  # 是否启用面包屑导航
  ShowBreadCrumbs: true
  # 是否显示代码复制按钮
  ShowCodeCopyButtons: true
  # 是否显示字数统计
  ShowWordCount: true
  # 是否在页面显示 RSS 按钮
  ShowRssButtonInSectionTermList: true
  UseHugoToc: true
  disableSpecial1stPost: false
  # 是否禁用首页滚动到顶部
  disableScrollToTop: false
  # 是否启用评论系统
  comments: true
  # 是否隐藏 Meta 信息
  hidemeta: false
  # 是否隐藏文章摘要
  hideSummary: false
  # 是否显示目录
  showtoc: false
  # 是否默认展开文章目录
  tocopen: false

  assets:
    # disableHLJS: true # to disable highlight.js
    # disableFingerprinting: true

    # 网站 Favicon 图标相关信息
    # 可在 https://realfavicongenerator.net/ 生成
    # 将图片复制到 /static 目录下
    # 然后修改下面代码中的文件名
    favicon: "feather.png"
    favicon16x16: "feather.png"
    favicon32x32: "feather.png"
    apple_touch_icon: "feather.png"
    safari_pinned_tab: "feather.png"
    disableHLJS: true # to disable highlight.js

  label:
    # 使用文本替代 Logo 标签
    text: LFL's Blog
    # 网站 Logo 图片（/static 下面的文件名称）
    icon: "R-C.jpeg"
    # 图标高度
    iconHeight: 45

  # 主页展示模式
  # 个人信息模式
  profileMode:
    enabled: false # needs to be explicitly set
    title: Welcome to my Blog
    subtitle: ""
    imageUrl: "blog.jpg"
    imageWidth: 120
    imageHeight: 120
    imageTitle: my image
    #buttons:
    #  - name: 文章
    #    url: posts/
    #  - name: bilibili
    #    url: X

  # 主页 - 信息模式（默认）
  homeInfoParams:
    Title: "Hi there ⛳"
    Content: Welcome to my blog
  #  主页 - 信息模式 图标展示
  socialIcons:
    - name: x
      url: "https://x.com/"
    - name: stackoverflow
      url: "https://stackoverflow.com"
    - name: github
      url: "https://github.com/"

  analytics:
    google:
      SiteVerificationTag: "XYZabc"
    bing:
      SiteVerificationTag: "XYZabc"
    yandex:
      SiteVerificationTag: "XYZabc"

  # 文章封面设置
  cover:
    hidden: true # hide everywhere but not in structured data
    hiddenInList: true # hide on list pages and home
    hiddenInSingle: true # hide on single page
  # 关联编辑
  editPost:
    URL: "https://github.com/<path_to_repo>/content"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link

  # for search
  # https://fusejs.io/api/options.html
  fuseOpts:
    isCaseSensitive: false
    shouldSort: true
    location: 0
    distance: 1000
    threshold: 0.4
    minMatchCharLength: 0
    limit: 10 # refer: https://www.fusejs.io/api/methods.html#search
    keys: ["title", "permalink", "summary", "content"]
pygmentsUseClasses: true
markup:
  goldmark:
    renderer:
      unsafe: true # 可以 unsafe，有些 html 标签和样式可能需要
  highlight:
    anchorLineNos: false # 不要给行号设置锚标
    codeFences: true # 代码围栏
    noClasses: false # TODO: 不知道干啥的，暂时没必要了解，不影响展示
    lineNos: true # 代码行
    lineNumbersInTable: false # 不要设置成 true，否则如果文章开头是代码的话，摘要会由一大堆数字(即代码行号)开头文章
    # 这里设置 style 没用，得自己加 css
    # style: "github-dark"
    # style: monokai

```

### 配置归档

在 `dev\content` 目录下新建 `archives.md` 文件，内容如下，

```markdown
---
title: "归档"
layout: "archives"
url: "/archives/"
summary: archives
---
```

### 创建一篇文章

在 `dev\content` 目录下新建 `posts` 文件夹，在`posts`文件夹下创建`my-first.md`文件写入下面数据

```markdown
---
title: 'Hugo + PaperMod + Github Pages 搭建一个完善的个人博客(以 Windows11 为例)'
date: 2025-03-02T11:01:38+08:00
categories: ["通用技术"]
tags: ["博客搭建", "Bilibili"]
---
```

在 `dev`目录打开终端，启动一下hugo输入以下命令

```powershell
hugo server
```

![image-20250305191210003](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305191210003.png)

按住ctr键单击红框，出现如下页面就表示成功了！

![image-20250305192329724](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305192329724.png)

看一下归档是否成功

![image-20250305192407809](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305192407809.png)

### 配置搜索

在`hugo.yaml`中加入

```yaml
# https://github.com/adityatelange/hugo-PaperMod/wiki/Features#search-page
outputs:
  home:
    - HTML # 生成的静态页面
    - RSS # 这个其实无所谓
    - JSON # necessary for search, 这里的配置修改好之后，一定要重新生成一下
```

然后，在 `dev\content` 目录下新建一个 `search.md` 文件，加入

```markdown
---
title: "搜索" # in any language you want
layout: "search" # necessary for search
summary: "search"
placeholder: "搜索"
---
```

然后是搜索的一些个性化设置，在`hugo.yaml`中找到`params`**注意缩进**

```yaml
params:
  # 搜索
  fuseOpts:
      isCaseSensitive: false # 是否大小写敏感
      shouldSort: true # 是否排序
      location: 0
      distance: 1000
      threshold: 0.4
      minMatchCharLength: 0
      # limit: 10 # refer: https://www.fusejs.io/api/methods.html#search
      keys: ["title", "permalink", "summary", "content"]
      includeMatches: true
```

这样以来，搜索就可以正常工作了，<br>在 `dev`目录打开终端，启动一下hugo输入以下命令

```
hugo server
```



![image-20250305193129599](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305193129599.png)

### 配置关于页面

新建两个文件，一个是 `dev\layouts\_default` 目录下的 `about.html`.没有`_default`文件夹就创建

```html
{{- define "main" }}
 
<header class="page-header">
    <h1>{{ .Title }}</h1>
    {{- if .Description }}
    <div class="post-description">
      {{ .Description }}
    </div>
    {{- end }}
  </header>
 
<section>
  <br>
  {{ .Content }}
</section>
 
{{- end }}{{/* end main */}}
```

另一个是 `dev\content` 目录下的 `about.md`,关于页面的信息直接写在`about.md`里面就行

```markdown
---
title: "关于"
layout: "about"
url: "/about/"
summary: about
---

这里就可以写一些关于的相关信息了。
```

在 `dev`目录打开终端，启动一下hugo输入以下命令

```powershell
hugo server
```

![image-20250305193837665](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305193837665.png)

### 配置评论

这里的评论使用了 giscus 插件。

先在 `dev\layouts\partials` 下新建一个 `comments.html` 文件，

``` html
<div id="tw-comment"></div>
<script>
    // 默认是暗色，根目录下的配置中的主题默认也是暗色
    const getStoredTheme = () => localStorage.getItem("pref-theme") === "light" ? "{{ .Site.Params.giscus.lightTheme }}" : "{{ .Site.Params.giscus.darkTheme }}";
    const setGiscusTheme = () => {
        const sendMessage = (message) => {
            const iframe = document.querySelector('iframe.giscus-frame');
            if (iframe) {
                iframe.contentWindow.postMessage({giscus: message}, 'https://giscus.app');
            }
        }
        sendMessage({setConfig: {theme: getStoredTheme()}})
    }

    document.addEventListener("DOMContentLoaded", () => {
        const giscusAttributes = {
            "src": "https://giscus.app/client.js",
            "data-repo": "{{ .Site.Params.giscus.repo }}",
            "data-repo-id": "{{ .Site.Params.giscus.repoId }}",
            "data-category": "{{ .Site.Params.giscus.category }}",
            "data-category-id": "{{ .Site.Params.giscus.categoryId }}",
            "data-mapping": "{{ .Site.Params.giscus.mapping }}",
            "data-strict": "{{ .Site.Params.giscus.strict }}",
            "data-reactions-enabled": "{{ .Site.Params.giscus.reactionsEnabled }}",
            "data-emit-metadata": "{{ .Site.Params.giscus.emitMetadata }}",
            "data-input-position": "{{ .Site.Params.giscus.inputPosition }}",
            "data-theme": getStoredTheme(),
            "data-lang": "{{ .Site.Params.giscus.lang }}",
            "data-loading": "lazy",
            "crossorigin": "anonymous",
        };

        // 动态创建 giscus script
        const giscusScript = document.createElement("script");
        Object.entries(giscusAttributes).forEach(
                ([key, value]) => giscusScript.setAttribute(key, value));
        document.querySelector("#tw-comment").appendChild(giscusScript);

        // 页面主题变更后，变更 giscus 主题
        const themeSwitcher = document.querySelector("#theme-toggle");
        if (themeSwitcher) {
            themeSwitcher.addEventListener("click", setGiscusTheme);
        }
        const themeFloatSwitcher = document.querySelector("#theme-toggle-float");
        if (themeFloatSwitcher) {
            themeFloatSwitcher.addEventListener("click", setGiscusTheme);
        }
    });
</script>
```

#### 🚅创建github仓库

​	进入[github](https://github.com/),注册账号就不赘述了。

![image-20250305194758367](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305194758367.png)

![image-20250305195011205](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305195011205.png)

![image-20250305195142569](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305195142569.png)

![image-20250305195304591](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305195304591.png)

#### 🚅配置giscus

然后，进入 [giscus](https://giscus.app/zh-CN) 官网，点击下图的链接

![image-20250305195513873](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305195513873.png)

![image-20250305195658705](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305195658705.png)

然后找到自己github仓库的设置

![image-20250305200009085](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305200009085.png)

![image-20250305200109578](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305200109578.png)

然后，进入 [giscus](https://giscus.app/zh-CN) 官网

![image-20250305200358744](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305200358744.png)

![image-20250305200711826](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305200711826.png)

然后，把相应的字段提取到`hugo.yaml`中，

```yaml
params:
  # 评论的设置
  giscus:
    repo: "sonnycalcr/sonnycalcr.github.io"
    repoId: "xxxxxx"
    category: "Announcements"
    categoryId: "xxxxx"
    mapping: "pathname"
    strict: "0"
    reactionsEnabled: "1"
    emitMetadata: "0"
    inputPosition: "bottom"
    lightTheme: "light"
    darkTheme: "dark"
    lang: "zh-CN"
    crossorigin: "anonymous"
```

这样就可以正常使用了。

![image-20250305201425169](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305201425169.png)

### 配置数学公式

这里使用的是 mathjax。

我们需要添加两个文件，一个是 `dev\layouts\partials` 下的 `mathjax.html` 文件，如下，

```html
<script type="text/javascript"
        async
        src="https://cdn.bootcss.com/mathjax/2.7.3/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
MathJax.Hub.Config({
  tex2jax: {
    inlineMath: [['$','$'], ['\\(','\\)']],
    displayMath: [['$$','$$'], ['\[\[','\]\]']],
    processEscapes: true,
    processEnvironments: true,
    skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
    TeX: { equationNumbers: { autoNumber: "AMS" },
         extensions: ["AMSmath.js", "AMSsymbols.js"] }
  }
});

MathJax.Hub.Queue(function() {
    // Fix <code> tags after MathJax finishes running. This is a
    // hack to overcome a shortcoming of Markdown. Discussion at
    // https://github.com/mojombo/jekyll/issues/199
    var all = MathJax.Hub.getAllJax(), i;
    for(i = 0; i < all.length; i += 1) {
        all[i].SourceElement().parentNode.className += ' has-jax';
    }
});
</script>

<style>
code.has-jax {
    font: inherit;
    font-size: 100%;
    background: inherit;
    border: inherit;
    color: #515151;
}
</style>
```

另一个是 `dev\layouts\partials` 下的 `extend_head.html` 文件，

```html
{{- /* Head custom content area start */ -}}
{{- /*     Insert any custom code (web-analytics, resources, etc.) - it will appear in the <head></head> section of every page. */ -}}
{{- /*     Can be overwritten by partial with the same name in the global layouts. */ -}}
{{ partial "mathjax.html" . }}
{{- /* Head custom content area end */ -}}
```

到这里，数学公式就可以正常使用了，把下面的代码复制到`dev\content\posts`下的`my-first.md`文件

```markdown
行内数学公式：$a^2 + b^2 = c^2$。

块公式，

$$
a^2 + b^2 = c^2
$$

<div>
$$
\boldsymbol{x}_{i+1}+\boldsymbol{x}_{i+2}=\boldsymbol{x}_{i+3}
$$
</div>
```

![image-20250305202058396](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305202058396.png)

上面的第二个公式之所以要用 div 包裹起来，是因为这里的数学公式如果有超过了三对花括号，那么，其解析和转义就会出问题，这个和 hugo 有关目前折中的方案就是上面这种在外面套一层 div。

### 添加代码字体

先到[谷歌字体](https://fonts.google.com/) 中找一款开源字体，我这里选用的是 Jetbrains Mono，然后复制其信息到`dev\layouts\partials\extend_head.html` 中，

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:ital,wght@0,100..800;1,100..800&display=swap" rel="stylesheet">
```

复制到这个位置

![image-20250305202433502](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305202433502.png)

然后，新建一个 `dev\assets\css\extended\blank.css` 文件，添加样式如下，

```css
.post-content pre,
code {
  font-family: "JetBrains Mono", monospace;
  font-size: 1rem;
  line-height: 1.2;
}
```

这样就可以生效了，如果发现不生效，可以重新执行一下 `hugo server` 试试。

### 代码明暗切换

我们先建立一个 `dev\assets\css\extended\chroma-styles-overrides.css` 文件，

**如果不想自己弄的话直接复制下面的css代码到新建的css文件中**

然后，执行一下命令生成你想要的样式，

```powershell
hugo gen chromastyles --style=tokyonight-day > syntax.css
```

然后，把 `syntax.css` 中的内容复制到 `chroma-styles-overrides.html` 文件中，如果是暗色主题，那么，生成的样式则要包裹在 `.dark {}` 里面，我这里生成了两个样式，白天的样式是 tokyonight-day，黑暗的样式是 github-dark，同时，要记得将生成的样式中有些空缺的部分给补上默认的颜色，我这里白天的颜色补的是黑色，夜晚的颜色补的是白色，不然代码的样式会出问题，我这里完整的样式如下，

```css
/* Background */ .bg { color:#3760bf;background-color:#e1e2e7; }
/* PreWrapper */ .chroma { color:#3760bf;background-color:#e1e2e7; }
/* Other */ .chroma .x { color: #000 }
/* Error */ .chroma .err { color:#c64343 }
/* CodeLine */ .chroma .cl { color: #000 }
/* LineLink */ .chroma .lnlinks { outline:none;text-decoration:none;color:inherit }
/* LineTableTD */ .chroma .lntd { vertical-align:top;padding:0;margin:0;border:0; }
/* LineTable */ .chroma .lntable { border-spacing:0;padding:0;margin:0;border:0; }
/* LineHighlight */ .chroma .hl { background-color:#a1a6c5 }
/* LineNumbersTable */ .chroma .lnt { white-space:pre;-webkit-user-select:none;user-select:none;margin-right:0.4em;padding:0 0.4em 0 0.4em;color:#6172b0 }
/* LineNumbers */ .chroma .ln { white-space:pre;-webkit-user-select:none;user-select:none;margin-right:0.4em;padding:0 0.4em 0 0.4em;color:#6172b0 }
/* Line */ .chroma .line { display:flex; }
/* Keyword */ .chroma .k { color:#9854f1 }
/* KeywordConstant */ .chroma .kc { color:#8c6c3e }
/* KeywordDeclaration */ .chroma .kd { color:#9d7cd8 }
/* KeywordNamespace */ .chroma .kn { color:#007197 }
/* KeywordPseudo */ .chroma .kp { color:#9854f1 }
/* KeywordReserved */ .chroma .kr { color:#9854f1 }
/* KeywordType */ .chroma .kt { color:#0db9d7 }
/* Name */ .chroma .n { color: #000 }
/* NameAttribute */ .chroma .na { color:#2e7de9 }
/* NameBuiltin */ .chroma .nb { color:#587539 }
/* NameBuiltinPseudo */ .chroma .bp { color:#587539 }
/* NameClass */ .chroma .nc { color:#b15c00 }
/* NameConstant */ .chroma .no { color:#b15c00 }
/* NameDecorator */ .chroma .nd { color:#2e7de9;font-weight:bold }
/* NameEntity */ .chroma .ni { color:#007197 }
/* NameException */ .chroma .ne { color:#8c6c3e }
/* NameFunction */ .chroma .nf { color:#2e7de9 }
/* NameFunctionMagic */ .chroma .fm { color:#2e7de9 }
/* NameLabel */ .chroma .nl { color:#587539 }
/* NameNamespace */ .chroma .nn { color:#8c6c3e }
/* NameOther */ .chroma .nx { color: #000 }
/* NameProperty */ .chroma .py { color:#8c6c3e }
/* NameTag */ .chroma .nt { color:#9854f1 }
/* NameVariable */ .chroma .nv { color: #000 }
/* NameVariableClass */ .chroma .vc { color: #000 }
/* NameVariableGlobal */ .chroma .vg { color: #000 }
/* NameVariableInstance */ .chroma .vi { color: #000 }
/* NameVariableMagic */ .chroma .vm { color: #000 }
/* Literal */ .chroma .l { color: #000 }
/* LiteralDate */ .chroma .ld { color: #000 }
/* LiteralString */ .chroma .s { color:#587539 }
/* LiteralStringAffix */ .chroma .sa { color:#9d7cd8 }
/* LiteralStringBacktick */ .chroma .sb { color:#587539 }
/* LiteralStringChar */ .chroma .sc { color:#587539 }
/* LiteralStringDelimiter */ .chroma .dl { color:#2e7de9 }
/* LiteralStringDoc */ .chroma .sd { color:#a1a6c5 }
/* LiteralStringDouble */ .chroma .s2 { color:#587539 }
/* LiteralStringEscape */ .chroma .se { color:#2e7de9 }
/* LiteralStringHeredoc */ .chroma .sh { color:#a1a6c5 }
/* LiteralStringInterpol */ .chroma .si { color:#587539 }
/* LiteralStringOther */ .chroma .sx { color:#587539 }
/* LiteralStringRegex */ .chroma .sr { color:#007197 }
/* LiteralStringSingle */ .chroma .s1 { color:#587539 }
/* LiteralStringSymbol */ .chroma .ss { color:#587539 }
/* LiteralNumber */ .chroma .m { color:#8c6c3e }
/* LiteralNumberBin */ .chroma .mb { color:#8c6c3e }
/* LiteralNumberFloat */ .chroma .mf { color:#8c6c3e }
/* LiteralNumberHex */ .chroma .mh { color:#8c6c3e }
/* LiteralNumberInteger */ .chroma .mi { color:#8c6c3e }
/* LiteralNumberIntegerLong */ .chroma .il { color:#8c6c3e }
/* LiteralNumberOct */ .chroma .mo { color:#8c6c3e }
/* Operator */ .chroma .o { color:#587539;font-weight:bold }
/* OperatorWord */ .chroma .ow { color:#587539;font-weight:bold }
/* Punctuation */ .chroma .p { color: #000 }
/* Comment */ .chroma .c { color:#a1a6c5;font-style:italic }
/* CommentHashbang */ .chroma .ch { color:#a1a6c5;font-style:italic }
/* CommentMultiline */ .chroma .cm { color:#a1a6c5;font-style:italic }
/* CommentSingle */ .chroma .c1 { color:#a1a6c5;font-style:italic }
/* CommentSpecial */ .chroma .cs { color:#a1a6c5;font-style:italic }
/* CommentPreproc */ .chroma .cp { color:#a1a6c5;font-style:italic }
/* CommentPreprocFile */ .chroma .cpf { color:#a1a6c5;font-weight:bold;font-style:italic }
/* Generic */ .chroma .g { color: #000 }
/* GenericDeleted */ .chroma .gd { color:#c64343;background-color:#e9e9ed }
/* GenericEmph */ .chroma .ge { font-style:italic }
/* GenericError */ .chroma .gr { color:#c64343 }
/* GenericHeading */ .chroma .gh { color:#8c6c3e;font-weight:bold }
/* GenericInserted */ .chroma .gi { color:#587539;background-color:#e9e9ed }
/* GenericOutput */ .chroma .go { color: #000 }
/* GenericPrompt */ .chroma .gp { color: #000 }
/* GenericStrong */ .chroma .gs { font-weight:bold }
/* GenericSubheading */ .chroma .gu { color:#8c6c3e;font-weight:bold }
/* GenericTraceback */ .chroma .gt { color:#c64343 }
/* GenericUnderline */ .chroma .gl { text-decoration:underline }
/* TextWhitespace */ .chroma .w { color: #000 }

.dark {
  /* Background */ .bg { color:#e6edf3;background-color:#0d1117; }
  /* PreWrapper */ .chroma { color:#e6edf3;background-color:#0d1117; }
  /* Other */ .chroma .x { color: #fff }
  /* Error */ .chroma .err { color:#f85149 }
  /* CodeLine */ .chroma .cl { color: #fff }
  /* LineLink */ .chroma .lnlinks { outline:none;text-decoration:none;color:inherit }
  /* LineTableTD */ .chroma .lntd { vertical-align:top;padding:0;margin:0;border:0; }
  /* LineTable */ .chroma .lntable { border-spacing:0;padding:0;margin:0;border:0; }
  /* LineHighlight */ .chroma .hl { background-color:#6e7681 }
  /* LineNumbersTable */ .chroma .lnt { white-space:pre;-webkit-user-select:none;user-select:none;margin-right:0.4em;padding:0 0.4em 0 0.4em;color:#737679 }
  /* LineNumbers */ .chroma .ln { white-space:pre;-webkit-user-select:none;user-select:none;margin-right:0.4em;padding:0 0.4em 0 0.4em;color:#6e7681 }
  /* Line */ .chroma .line { display:flex; }
  /* Keyword */ .chroma .k { color:#ff7b72 }
  /* KeywordConstant */ .chroma .kc { color:#79c0ff }
  /* KeywordDeclaration */ .chroma .kd { color:#ff7b72 }
  /* KeywordNamespace */ .chroma .kn { color:#ff7b72 }
  /* KeywordPseudo */ .chroma .kp { color:#79c0ff }
  /* KeywordReserved */ .chroma .kr { color:#ff7b72 }
  /* KeywordType */ .chroma .kt { color:#ff7b72 }
  /* Name */ .chroma .n { color: #fff }
  /* NameAttribute */ .chroma .na { color: #fff }
  /* NameBuiltin */ .chroma .nb { color: #fff }
  /* NameBuiltinPseudo */ .chroma .bp { color: #fff }
  /* NameClass */ .chroma .nc { color:#f0883e;font-weight:bold }
  /* NameConstant */ .chroma .no { color:#79c0ff;font-weight:bold }
  /* NameDecorator */ .chroma .nd { color:#d2a8ff;font-weight:bold }
  /* NameEntity */ .chroma .ni { color:#ffa657 }
  /* NameException */ .chroma .ne { color:#f0883e;font-weight:bold }
  /* NameFunction */ .chroma .nf { color:#d2a8ff;font-weight:bold }
  /* NameFunctionMagic */ .chroma .fm { color: #fff }
  /* NameLabel */ .chroma .nl { color:#79c0ff;font-weight:bold }
  /* NameNamespace */ .chroma .nn { color:#ff7b72 }
  /* NameOther */ .chroma .nx { color: #fff }
  /* NameProperty */ .chroma .py { color:#79c0ff }
  /* NameTag */ .chroma .nt { color:#7ee787 }
  /* NameVariable */ .chroma .nv { color:#79c0ff }
  /* NameVariableClass */ .chroma .vc { color: #fff }
  /* NameVariableGlobal */ .chroma .vg { color: #fff }
  /* NameVariableInstance */ .chroma .vi { color: #fff }
  /* NameVariableMagic */ .chroma .vm { color: #fff }
  /* Literal */ .chroma .l { color:#a5d6ff }
  /* LiteralDate */ .chroma .ld { color:#79c0ff }
  /* LiteralString */ .chroma .s { color:#a5d6ff }
  /* LiteralStringAffix */ .chroma .sa { color:#79c0ff }
  /* LiteralStringBacktick */ .chroma .sb { color:#a5d6ff }
  /* LiteralStringChar */ .chroma .sc { color:#a5d6ff }
  /* LiteralStringDelimiter */ .chroma .dl { color:#79c0ff }
  /* LiteralStringDoc */ .chroma .sd { color:#a5d6ff }
  /* LiteralStringDouble */ .chroma .s2 { color:#a5d6ff }
  /* LiteralStringEscape */ .chroma .se { color:#79c0ff }
  /* LiteralStringHeredoc */ .chroma .sh { color:#79c0ff }
  /* LiteralStringInterpol */ .chroma .si { color:#a5d6ff }
  /* LiteralStringOther */ .chroma .sx { color:#a5d6ff }
  /* LiteralStringRegex */ .chroma .sr { color:#79c0ff }
  /* LiteralStringSingle */ .chroma .s1 { color:#a5d6ff }
  /* LiteralStringSymbol */ .chroma .ss { color:#a5d6ff }
  /* LiteralNumber */ .chroma .m { color:#a5d6ff }
  /* LiteralNumberBin */ .chroma .mb { color:#a5d6ff }
  /* LiteralNumberFloat */ .chroma .mf { color:#a5d6ff }
  /* LiteralNumberHex */ .chroma .mh { color:#a5d6ff }
  /* LiteralNumberInteger */ .chroma .mi { color:#a5d6ff }
  /* LiteralNumberIntegerLong */ .chroma .il { color:#a5d6ff }
  /* LiteralNumberOct */ .chroma .mo { color:#a5d6ff }
  /* Operator */ .chroma .o { color:#ff7b72;font-weight:bold }
  /* OperatorWord */ .chroma .ow { color:#ff7b72;font-weight:bold }
  /* Punctuation */ .chroma .p { color: #fff }
  /* Comment */ .chroma .c { color:#8b949e;font-style:italic }
  /* CommentHashbang */ .chroma .ch { color:#8b949e;font-style:italic }
  /* CommentMultiline */ .chroma .cm { color:#8b949e;font-style:italic }
  /* CommentSingle */ .chroma .c1 { color:#8b949e;font-style:italic }
  /* CommentSpecial */ .chroma .cs { color:#8b949e;font-weight:bold;font-style:italic }
  /* CommentPreproc */ .chroma .cp { color:#8b949e;font-weight:bold;font-style:italic }
  /* CommentPreprocFile */ .chroma .cpf { color:#8b949e;font-weight:bold;font-style:italic }
  /* Generic */ .chroma .g { color: #fff }
  /* GenericDeleted */ .chroma .gd { color:#ffa198;background-color:#490202 }
  /* GenericEmph */ .chroma .ge { font-style:italic }
  /* GenericError */ .chroma .gr { color:#ffa198 }
  /* GenericHeading */ .chroma .gh { color:#79c0ff;font-weight:bold }
  /* GenericInserted */ .chroma .gi { color:#56d364;background-color:#0f5323 }
  /* GenericOutput */ .chroma .go { color:#8b949e }
  /* GenericPrompt */ .chroma .gp { color:#8b949e }
  /* GenericStrong */ .chroma .gs { font-weight:bold }
  /* GenericSubheading */ .chroma .gu { color:#79c0ff }
  /* GenericTraceback */ .chroma .gt { color:#ff7b72 }
  /* GenericUnderline */ .chroma .gl { text-decoration:underline }
  /* TextWhitespace */ .chroma .w { color:#6e7681 }
}
```

我们再建立一个 `dev\assets\css\extended\theme-vars-override.css` 文件，

``` css
:root {
    --gap: 24px;
    --content-gap: 20px;
    --nav-width: 1024px;
    --main-width: 720px;
    --header-height: 60px;
    --footer-height: 60px;
    --radius: 8px;
    --theme: rgb(255, 255, 255);
    --entry: rgb(255, 255, 255);
    --primary: rgb(30, 30, 30);
    --secondary: rgb(108, 108, 108);
    --tertiary: rgb(214, 214, 214);
    --content: rgb(31, 31, 31);
    --code-block-bg: rgb(245, 245, 245);
    --code-bg: rgb(245, 245, 245);
    --border: rgb(238, 238, 238);
}

.dark {
    --theme: rgb(29, 30, 32);
    --entry: rgb(46, 46, 51);
    --primary: rgb(218, 218, 219);
    --secondary: rgb(155, 156, 157);
    --tertiary: rgb(65, 66, 68);
    --content: rgb(196, 196, 197);
    --code-block-bg: rgb(46, 46, 51);
    --code-bg: rgb(46, 46, 51);
    --border: rgb(51, 51, 51);
}
```

然后，修改一下配置即可，

``` yaml
params:
  assets:
      disableHLJS: true
markup:
  goldmark:
    renderer:
      unsafe: true # 可以 unsafe，有些 html 标签和样式可能需要
  highlight:
    anchorLineNos: false # 不要给行号设置锚标
    codeFences: true # 代码围栏
    noClasses: false # TODO: 不知道干啥的，暂时没必要了解，不影响展示
    lineNos: true # 代码行
    lineNumbersInTable: false # 不要设置成 true，否则如果文章开头是代码的话，摘要会由一大堆数字(即代码行号)开头文章
    # 这里设置 style 没用，得自己加 css
    # style: "github-dark"
    # style: monokai
```

到这里就可以明暗切换了

### 修改网页的 favicon

先到 [flaticon](https://www.flaticon.com/) 网站中找一个 icon 图片，然后放到 static 目录下，

然后，修改配置，

```yaml
params:
  # 设置网站的标签页的图标，即 favicon
  assets:
      favicon: "favicon.png"
      favicon16x16: "favicon.png"
      favicon32x32: "favicon.png"
      apple_touch_icon: "favicon.png"
      safari_pinned_tab: "favicon.png"
```

下面是一些css的简单样式（可选）

我们再建立一个 `dev\assets\css\extended\scroll-bar-overrides.css` 文件，

```css
/* from reset */
::-webkit-scrollbar-track {
    background: 0 0;
}

.list:not(.dark)::-webkit-scrollbar-track {
    background: var(--code-bg);
}

::-webkit-scrollbar-thumb {
    background: var(--tertiary);
    border: 5px solid var(--theme);
    border-radius: 0;
}
::-webkit-scrollbar-thumb:hover {
    background: var(--secondary);
}

.list:not(.dark)::-webkit-scrollbar-thumb {
    border: 5px solid var(--code-bg);
}


::-webkit-scrollbar:not(.highlighttable, .highlight table, .gist .highlight) {
    background: var(--theme);
}

/* from post-single */
.post-content .highlighttable td .highlight pre code::-webkit-scrollbar {
    display: none;
}

/**/
/* 代码块的滚动条 */
/**/
.post-content :not(table) ::-webkit-scrollbar-thumb {
    border: 2px solid var(--code-block-bg);
    /*background: rgb(113, 113, 117);*/
    background: var(--tertiary);
}
/* 鼠标悬浮在上面的时候 */
.post-content :not(table) ::-webkit-scrollbar-thumb:hover {
    /*background: rgb(163, 163, 165);*/
    background: var(--secondary);
}

.gist table::-webkit-scrollbar-thumb {
    border: 2px solid rgb(255, 255, 255);
    background: rgb(173, 173, 173);
}

.gist table::-webkit-scrollbar-thumb:hover {
    background: rgb(112, 112, 112);
}

.post-content table::-webkit-scrollbar-thumb {
    border-width: 2px;
}

/* from zmedia */
/* 这里将 min-width 设置得尽量小一点，是为了防止在移动端的滚动条的样式失效 */
@media screen and (min-width: 100px) {

    /* reset */
    ::-webkit-scrollbar {
        width: 19px;
        height: 11px;
    }
}
```

我们再建立一个 `dev\assets\css\extended\footer-overrides.css` 文件，

``` css
/* 移动设备中应该隐藏掉 scroll-to-top de 按钮 */
@media (width < 600px) {
  #top-link {
    display: none;
  }
}
```

### 配置侧边目录

官方的默认目录形式很不方便，查看目录还需要翻到最上面，[详细内容](https://cloud.tencent.com/developer/article/1944127)

#### 🚅toc代码

先找到目录 layouts/partials/toc.html ，把之前的代码换成如下代码

```javascript
{{- $headers := findRE "<h[1-6].*?>(.|\n])+?</h[1-6]>" .Content -}}
{{- $has_headers := ge (len $headers) 1 -}}
{{- if $has_headers -}}
<aside id="toc-container" class="toc-container wide">
    <div class="toc">
        <details {{if (.Param "TocOpen") }} open{{ end }}>
            <summary accesskey="c" title="(Alt + C)">
                <span class="details">{{- i18n "toc" | default "Table of Contents" }}</span>
            </summary>

            <div class="inner">
                {{- $largest := 6 -}}
                {{- range $headers -}}
                {{- $headerLevel := index (findRE "[1-6]" . 1) 0 -}}
                {{- $headerLevel := len (seq $headerLevel) -}}
                {{- if lt $headerLevel $largest -}}
                {{- $largest = $headerLevel -}}
                {{- end -}}
                {{- end -}}

                {{- $firstHeaderLevel := len (seq (index (findRE "[1-6]" (index $headers 0) 1) 0)) -}}

                {{- $.Scratch.Set "bareul" slice -}}
                <ul>
                    {{- range seq (sub $firstHeaderLevel $largest) -}}
                    <ul>
                        {{- $.Scratch.Add "bareul" (sub (add $largest .) 1) -}}
                        {{- end -}}
                        {{- range $i, $header := $headers -}}
                        {{- $headerLevel := index (findRE "[1-6]" . 1) 0 -}}
                        {{- $headerLevel := len (seq $headerLevel) -}}

                        {{/* get id="xyz" */}}
                        {{- $id := index (findRE "(id=\"(.*?)\")" $header 9) 0 }}

                        {{- /* strip id="" to leave xyz, no way to get regex capturing groups in hugo */ -}}
                        {{- $cleanedID := replace (replace $id "id=\"" "") "\"" "" }}
                        {{- $header := replaceRE "<h[1-6].*?>((.|\n])+?)</h[1-6]>" "$1" $header -}}

                        {{- if ne $i 0 -}}
                        {{- $prevHeaderLevel := index (findRE "[1-6]" (index $headers (sub $i 1)) 1) 0 -}}
                        {{- $prevHeaderLevel := len (seq $prevHeaderLevel) -}}
                        {{- if gt $headerLevel $prevHeaderLevel -}}
                        {{- range seq $prevHeaderLevel (sub $headerLevel 1) -}}
                        <ul>
                            {{/* the first should not be recorded */}}
                            {{- if ne $prevHeaderLevel . -}}
                            {{- $.Scratch.Add "bareul" . -}}
                            {{- end -}}
                            {{- end -}}
                            {{- else -}}
                            </li>
                            {{- if lt $headerLevel $prevHeaderLevel -}}
                            {{- range seq (sub $prevHeaderLevel 1) -1 $headerLevel -}}
                            {{- if in ($.Scratch.Get "bareul") . -}}
                        </ul>
                        {{/* manually do pop item */}}
                        {{- $tmp := $.Scratch.Get "bareul" -}}
                        {{- $.Scratch.Delete "bareul" -}}
                        {{- $.Scratch.Set "bareul" slice}}
                        {{- range seq (sub (len $tmp) 1) -}}
                        {{- $.Scratch.Add "bareul" (index $tmp (sub . 1)) -}}
                        {{- end -}}
                        {{- else -}}
                    </ul>
                    </li>
                    {{- end -}}
                    {{- end -}}
                    {{- end -}}
                    {{- end }}
                    <li>
                        <a href="#{{- $cleanedID -}}" aria-label="{{- $header | plainify -}}">{{- $header | safeHTML -}}</a>
                        {{- else }}
                    <li>
                        <a href="#{{- $cleanedID -}}" aria-label="{{- $header | plainify -}}">{{- $header | safeHTML -}}</a>
                        {{- end -}}
                        {{- end -}}
                        <!-- {{- $firstHeaderLevel := len (seq (index (findRE "[1-6]" (index $headers 0) 1) 0)) -}} -->
                        {{- $firstHeaderLevel := $largest }}
                        {{- $lastHeaderLevel := len (seq (index (findRE "[1-6]" (index $headers (sub (len $headers) 1)) 1) 0)) }}
                    </li>
                    {{- range seq (sub $lastHeaderLevel $firstHeaderLevel) -}}
                    {{- if in ($.Scratch.Get "bareul") (add . $firstHeaderLevel) }}
                </ul>
                {{- else }}
                </ul>
                </li>
                {{- end -}}
                {{- end }}
                </ul>
            </div>
        </details>
    </div>
</aside>
<script>
    let activeElement;
    let elements;
    window.addEventListener('DOMContentLoaded', function (event) {
        checkTocPosition();

        elements = document.querySelectorAll('h1[id],h2[id],h3[id],h4[id],h5[id],h6[id]');
         // Make the first header active
         activeElement = elements[0];
         const id = encodeURI(activeElement.getAttribute('id')).toLowerCase();
         document.querySelector(`.inner ul li a[href="#${id}"]`).classList.add('active');
     }, false);

    window.addEventListener('resize', function(event) {
        checkTocPosition();
    }, false);

    window.addEventListener('scroll', () => {
        // Check if there is an object in the top half of the screen or keep the last item active
        activeElement = Array.from(elements).find((element) => {
            if ((getOffsetTop(element) - window.pageYOffset) > 0 && 
                (getOffsetTop(element) - window.pageYOffset) < window.innerHeight/2) {
                return element;
            }
        }) || activeElement

        elements.forEach(element => {
             const id = encodeURI(element.getAttribute('id')).toLowerCase();
             if (element === activeElement){
                 document.querySelector(`.inner ul li a[href="#${id}"]`).classList.add('active');
             } else {
                 document.querySelector(`.inner ul li a[href="#${id}"]`).classList.remove('active');
             }
         })
     }, false);

    const main = parseInt(getComputedStyle(document.body).getPropertyValue('--article-width'), 10);
    const toc = parseInt(getComputedStyle(document.body).getPropertyValue('--toc-width'), 10);
    const gap = parseInt(getComputedStyle(document.body).getPropertyValue('--gap'), 10);

    function checkTocPosition() {
        const width = document.body.scrollWidth;

        if (width - main - (toc * 2) - (gap * 4) > 0) {
            document.getElementById("toc-container").classList.add("wide");
        } else {
            document.getElementById("toc-container").classList.remove("wide");
        }
    }

    function getOffsetTop(element) {
        if (!element.getClientRects().length) {
            return 0;
        }
        let rect = element.getBoundingClientRect();
        let win = element.ownerDocument.defaultView;
        return rect.top + win.pageYOffset;   
    }
</script>
{{- end }}
```

#### 🚅调用代码

找到目录 layouts/_default/about.html

```javascript
  {{- if (.Param "ShowToc") }}
  {{- partial "toc.html" . }}
  {{- end }}
```

大概是这个位置，看着放

![image-20250503133019871](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250503133019871.png)

#### 🚅修改css

找到目录 css/extended/blank.css ，添加如下代码，

```css
:root {
    --nav-width: 1380px;
    --article-width: 650px;
    --toc-width: 300px;
}

.toc {
    margin: 0 2px 40px 2px;
    border: 1px solid var(--border);
    background: var(--entry);
    border-radius: var(--radius);
    padding: 0.4em;
}

.toc-container.wide {
    position: absolute;
    height: 100%;
    border-right: 1px solid var(--border);
    left: calc((var(--toc-width) + var(--gap)) * -1);
    top: calc(var(--gap) * 2);
    width: var(--toc-width);
}

.wide .toc {
    position: sticky;
    top: var(--gap);
    border: unset;
    background: unset;
    border-radius: unset;
    width: 100%;
    margin: 0 2px 40px 2px;
}

.toc details summary {
    cursor: zoom-in;
    margin-inline-start: 20px;
    padding: 12px 0;
}

.toc details[open] summary {
    font-weight: 500;
}

.toc-container.wide .toc .inner {
    margin: 0;
}

.active {
    font-size: 110%;
    font-weight: 600;
}

.toc ul {
    list-style-type: circle;
}

.toc .inner {
    margin: 0 0 0 20px;
    padding: 0px 15px 15px 20px;
    font-size: 16px;
}

.toc li ul {
    margin-inline-start: calc(var(--gap) * 0.5);
    list-style-type: none;
}

.toc li {
    list-style: none;
    font-size: 0.95rem;
    padding-bottom: 5px;
}

.toc li a:hover {
    color: var(--secondary);
}
```







## 4. 部署到 Github Pages

我们这里就选用简单的第一种比较直接的方式。

新建一个仓库，没有什么好说的，然后把我们当前的这个仓库和远程仓库关联起来，然后推送过去。然后按照 Hugo 的[文档](https://gohugo.io/hosting-and-deployment/hosting-on-github/)指导来操作即可。

打开github仓库的设置

![image-20250305210630057](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305210630057.png)

在dev下打开终端输入

```powershell
git add .
git commit -m "update"
git branch -M main
git remote add origin https://github.com/用户名/仓库名.git
git push -u origin main
```

刷新几下等github部署完成会出现下图，点击链接，会发现网页404错误，这是正常现象

![image-20250305210937332](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305210937332.png)

创建`dev/.github/workflows/hugo.yaml`

```yaml
# Sample workflow for building and deploying a Hugo site to GitHub Pages
name: Deploy Hugo site to Pages

on:
  # Runs on pushes targeting the default branch
  push:
    branches:
      - main

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow only one concurrent deployment, skipping runs queued between the run in-progress and latest queued.
# However, do NOT cancel in-progress runs as we want to allow these production deployments to complete.
concurrency:
  group: "pages"
  cancel-in-progress: false

# Default to bash
defaults:
  run:
    shell: bash

jobs:
  # Build job
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.144.2
    steps:
      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb
      - name: Install Dart Sass
        run: sudo snap install dart-sass
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5
      - name: Install Node.js dependencies
        run: "[[ -f package-lock.json || -f npm-shrinkwrap.json ]] && npm ci || true"
      - name: Build with Hugo
        env:
          HUGO_CACHEDIR: ${{ runner.temp }}/hugo_cache
          HUGO_ENVIRONMENT: production
          TZ: America/Los_Angeles
        run: |
          hugo \
            --gc \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/"
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  # Deployment job
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

下面这两个地方需要改一下

![image-20250305211243854](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305211243854.png)

在终端输入,查看hugo版本

```powershell
hugo version
```

![image-20250305211403920](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305211403920.png)

如图修改，github上面也能看分支，对应修改就行

![image-20250305211449726](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305211449726.png)

最后推送一下,以后添加了文章直接使用下面代码就可以上传到github上

```powershell
git add .
git commit -m "update2"
git push
```

![image-20250305212024927](https://gitee.com/a-cake-tree/typora-image/raw/master/image-20250305212024927.png)

完事儿。

## 5. 故障修复

网站打开发现主题没有应用上去，[PaperMod](https://github.com/adityatelange/hugo-PaperMod/archive/master.zip)点链接下载一下。<br>下载好之后有一个PaperMod文件夹，将他与`dev\themes\PaperMod`文件夹替换<br>然后，推送一下

```powershell
git add .
git commit -m "update2"
git push
```

## 6. 项目目录

```powershell
C:\USERS\LFL\HUGO\DEV
│  .gitignore
│  .gitmodules
│  .hugo_build.lock
│  hugo.yaml
│
├─.github
│  └─workflows
│          hugo.yaml
│
├─archetypes
│      default.md
│
├─assets
│  └─css
│      └─extended
│              blank.css
│              chroma-styles-overrides.css
│
├─content
│  │  about.md
│  │  archives.md
│  │  search.md
│  │
│  └─posts
│          my-first.md
│
├─data
├─i18n
├─layouts
│  ├─partials
│  │      comments.html
│  │      extend_head.html
│  │      mathjax.html
│  │
│  └─_default
│          about.html
│
├─public
│  │  404.html
│  │  index.html
│  │  index.json
│  │  index.xml
│  │  robots.txt
│  │  sitemap.xml
│  │
│  ├─about
│  │      index.html
│  │
│  ├─archives
│  │      index.html
│  │
│  ├─assets
│  │  ├─css
│  │  │      stylesheet.7e29a6932e46dab2e64f09b88f1364af287effdd98eaff77b2ff32b42c5679e3.css
│  │  │
│  │  └─js
│  │          search.21902eb1eaf2a5055095350eeb73f1755a5d7d2b4f31e302e5fec6a0f4ba4456.js
│  │
│  ├─categories
│  │  │  index.html
│  │  │  index.xml
│  │  │
│  │  └─通用技术
│  │      │  index.html
│  │      │  index.xml
│  │      │
│  │      └─page
│  │          └─1
│  │                  index.html
│  │
│  ├─page
│  │  └─1
│  │          index.html
│  │
│  ├─posts
│  │  │  index.html
│  │  │  index.xml
│  │  │
│  │  ├─my-first
│  │  │      index.html
│  │  │
│  │  └─page
│  │      └─1
│  │              index.html
│  │
│  ├─search
│  │      index.html
│  │
│  └─tags
│      │  index.html
│      │  index.xml
│      │
│      ├─bilibili
│      │  │  index.html
│      │  │  index.xml
│      │  │
│      │  └─page
│      │      └─1
│      │              index.html
│      │
│      └─博客搭建
│          │  index.html
│          │  index.xml
│          │
│          └─page
│              └─1
│                      index.html
│
├─resources
│  └─_gen
│      ├─assets
│      └─images
├─static
└─themes
    └─PaperMod
        │  go.mod
        │  LICENSE
        │  README.md
        │  theme.toml
        │
        ├─.github
        │  │  PULL_REQUEST_TEMPLATE.md
        │  │
        │  ├─ISSUE_TEMPLATE
        │  │      bug.yaml
        │  │      config.yml
        │  │      enhancement.yaml
        │  │
        │  └─workflows
        │          gh-pages.yml
        │
        ├─assets
        │  ├─css
        │  │  ├─common
        │  │  │      404.css
        │  │  │      archive.css
        │  │  │      footer.css
        │  │  │      header.css
        │  │  │      main.css
        │  │  │      post-entry.css
        │  │  │      post-single.css
        │  │  │      profile-mode.css
        │  │  │      search.css
        │  │  │      terms.css
        │  │  │
        │  │  ├─core
        │  │  │      license.css
        │  │  │      reset.css
        │  │  │      theme-vars.css
        │  │  │      zmedia.css
        │  │  │
        │  │  ├─extended
        │  │  │      blank.css
        │  │  │
        │  │  └─includes
        │  │          chroma-mod.css
        │  │          chroma-styles.css
        │  │          scroll-bar.css
        │  │
        │  └─js
        │          fastsearch.js
        │          fuse.basic.min.js
        │          license.js
        │
        ├─i18n
        │      ar.yaml
        │      be.yaml
        │      bg.yaml
        │      bn.yaml
        │      ca.yaml
        │      ckb.yaml
        │      cs.yaml
        │      da.yaml
        │      de.yaml
        │      el.yaml
        │      en.yaml
        │      eo.yaml
        │      es.yaml
        │      fa.yaml
        │      fr.yaml
        │      he.yaml
        │      hi.yaml
        │      hr.yaml
        │      hu.yaml
        │      id.yaml
        │      it.yaml
        │      ja.yaml
        │      ko.yaml
        │      ku.yaml
        │      mn.yaml
        │      ms.yaml
        │      nl.yaml
        │      no.yaml
        │      oc.yaml
        │      pa.yaml
        │      pl.yaml
        │      pnb.yaml
        │      pt.yaml
        │      ro.yaml
        │      ru.yaml
        │      sk.yaml
        │      sv.yaml
        │      sw.yaml
        │      th.yaml
        │      tr.yaml
        │      uk.yaml
        │      uz.yaml
        │      vi.yaml
        │      zh-tw.yaml
        │      zh.yaml
        │
        ├─images
        │      screenshot.png
        │      tn.png
        │
        └─layouts
            │  404.html
            │  robots.txt
            │
            ├─partials
            │  │  anchored_headings.html
            │  │  author.html
            │  │  breadcrumbs.html
            │  │  comments.html
            │  │  cover.html
            │  │  edit_post.html
            │  │  extend_footer.html
            │  │  extend_head.html
            │  │  footer.html
            │  │  head.html
            │  │  header.html
            │  │  home_info.html
            │  │  index_profile.html
            │  │  post_canonical.html
            │  │  post_meta.html
            │  │  post_nav_links.html
            │  │  share_icons.html
            │  │  social_icons.html
            │  │  svg.html
            │  │  toc.html
            │  │  translation_list.html
            │  │
            │  └─templates
            │      │  opengraph.html
            │      │  schema_json.html
            │      │  twitter_cards.html
            │      │
            │      └─_funcs
            │              get-page-images.html
            │
            ├─shortcodes
            │      collapse.html
            │      figure.html
            │      inTextImg.html
            │      ltr.html
            │      rawhtml.html
            │      rtl.html
            │
            └─_default
                │  archives.html
                │  baseof.html
                │  index.json
                │  list.html
                │  rss.xml
                │  search.html
                │  single.html
                │  terms.html
                │
                └─_markup
                        render-image.html
```

## 7. 文章模板

文章模板是文章头部的基本配置，当你使用下面命令创建md文件时，基本配置会自动加入<br>`dev\archetypes\default.md`修改成下面代码

```markdown
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
lastmod: {{ .Date }}
draft: true # 是否为草稿
author: ["tkk"]

categories: []

tags: []

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
#不加这个的话图床的图片会被浏览器墙掉
<meta name="referrer" content="no-referrer" />

```



