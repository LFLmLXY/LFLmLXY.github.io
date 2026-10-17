#Requires -Version 5.1
<#
    blog.ps1 —— 发文章 / 本地预览 / 部署到 GitHub Pages

       .\blog new "标题" [-Slug my-post] [-Tags "docker","linux"] [-Categories "折腾"]
       .\blog preview
       .\blog deploy ["提交说明"]

    推送到 main 之后，GitHub Actions 会自动构建并发布到 LFLmLXY.github.io。
    平时不需要手动跑 hugo，部署这一步只是本地先校验一遍构建有没有报错。

    注意：本文件要保存为 UTF-8 with BOM，否则 Windows PowerShell 5.1 会把中文读成乱码。
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet('new', 'preview', 'deploy', 'help')]
    [string]$Action = 'help',

    [Parameter(Position = 1)]
    [string]$Arg,

    [string]$Slug,
    [string[]]$Tags,
    [string[]]$Categories,

    [switch]$NoBuild,   # deploy: 跳过本地 hugo 构建校验
    [switch]$NoPush,    # deploy: 只提交不推送
    [switch]$SkipPull   # deploy: 不执行 git pull --rebase
)

# 脚本大量调用 git / hugo 这类原生命令，出错要我自己判断并给出人话提示，
# 所以这里用 Continue 而不是 Stop（Stop 会让 stderr 直接中断脚本）
$ErrorActionPreference = 'Continue'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$Root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $Root

$PostsDir = Join-Path $Root 'content\posts'
$SiteUrl = 'https://LFLmLXY.github.io/'
$ActionsUrl = 'https://github.com/LFLmLXY/LFLmLXY.github.io/actions'

function Write-Step($Text) { Write-Host "`n>  $Text" -ForegroundColor Cyan }
function Write-Ok($Text) { Write-Host "OK $Text" -ForegroundColor Green }
function Write-Warn2($Text) { Write-Host "!  $Text" -ForegroundColor Yellow }
function Write-Bad($Text) { Write-Host "X  $Text" -ForegroundColor Red }

function Show-Help {
    Write-Host ''
    Write-Host "  LFL's Blog 小助手" -ForegroundColor Magenta
    Write-Host ''
    Write-Host '  .\blog new "标题"                      新建文章（默认草稿）' -ForegroundColor Gray
    Write-Host '       [-Slug my-post]                  网址用的英文短名' -ForegroundColor DarkGray
    Write-Host '       [-Tags "docker","linux"]          直接写好标签' -ForegroundColor DarkGray
    Write-Host '       [-Categories "折腾"]              直接写好分类' -ForegroundColor DarkGray
    Write-Host ''
    Write-Host '  .\blog preview                        本地预览（含草稿），改文件自动刷新' -ForegroundColor Gray
    Write-Host ''
    Write-Host '  .\blog deploy                         构建校验 + 提交 + 推送，自动发布上线' -ForegroundColor Gray
    Write-Host '       .\blog deploy "改了导航"           自定义提交说明' -ForegroundColor DarkGray
    Write-Host '       [-NoBuild] [-SkipPull] [-NoPush]  按需跳过某一步' -ForegroundColor DarkGray
    Write-Host ''
    Write-Host "  站点 $SiteUrl" -ForegroundColor DarkGray
    Write-Host ''
}

function Test-Hugo {
    if (Get-Command hugo -ErrorAction SilentlyContinue) { return $true }
    Write-Warn2 'PATH 里找不到 hugo，跳过本地构建（只影响预览和校验，不影响线上发布）'
    return $false
}

function Get-CurrentBranch {
    $branch = (& git rev-parse --abbrev-ref HEAD 2>$null)
    if ($LASTEXITCODE -ne 0) { return $null }
    return "$branch".Trim()
}

# 跑一条 git 命令，把输出抓下来自己判断（避免 stderr 变成红色报错块）
function Invoke-Git-Net {
    param([string[]]$GitArgs)
    $lines = & git @GitArgs 2>&1 | ForEach-Object { "$_" }
    return [pscustomobject]@{ Code = $LASTEXITCODE; Text = (($lines -join "`n").TrimEnd()) }
}

# 判断失败原因是不是「网络 / 代理」，而不是冲突
function Test-NetworkError {
    param([string]$Text)
    return ($Text -match 'Failed to connect|Could not resolve|Connection refused|Operation timed out|timed out|schannel|certificate|unable to access|Authentication failed|403|proxy')
}

# 浏览器正在用的系统代理（Windows 自己的设置，git 不会自动读它）
function Get-SystemProxy {
    try {
        $ie = Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction Stop
        if ($ie.ProxyEnable -eq 1 -and $ie.ProxyServer) {
            $s = "$($ie.ProxyServer)"
            if ($s -match '=') {
                $m = [regex]::Match($s, 'https?=([^;]+)')
                if ($m.Success) { $s = $m.Groups[1].Value }
            }
            return $s.Trim()
        }
    }
    catch { }
    return $null
}

function Show-ProxyTip {
    param([string]$Text)

    $proxy = (& git config --get http.proxy 2>$null)
    if ($proxy) { Write-Host "  git 现在的代理配置: $proxy" -ForegroundColor Gray }

    $sys = Get-SystemProxy
    if ($sys) {
        Write-Host "  系统代理（浏览器用的）: $sys" -ForegroundColor Gray
        $gitHost = "$proxy" -replace '^https?://', ''
        if ($gitHost -and $gitHost.TrimEnd('/') -ne $sys) {
            Write-Host '  ! 两个地址不一致 —— git 很可能连的是个没在监听的端口' -ForegroundColor Yellow
            Write-Host "    改一下: git config http.proxy http://$sys" -ForegroundColor Yellow
        }
    }

    if ($Text -match 'schannel|SEC_E_NO_CREDENTIALS|certificate') {
        Write-Host '  ! 这是 TLS 证书层的问题，可以换后端:' -ForegroundColor Yellow
        Write-Host '    git config http.sslBackend openssl' -ForegroundColor Yellow
    }

    Write-Host '  其它排查:' -ForegroundColor Gray
    Write-Host '    - 代理软件没开就先开起来，然后重跑' -ForegroundColor Gray
    Write-Host '    - 想直连: git config --global --unset http.proxy' -ForegroundColor Gray
    Write-Host '    - 测连通: git ls-remote origin' -ForegroundColor Gray
}

# 用 .cmd 或 -File 传参时，数组会被塞成一个 "a,b" 字符串，这里统一拆开
function Split-List($Value) {
    $out = @()
    foreach ($item in $Value) {
        foreach ($part in ("$item" -split ',')) {
            $clean = $part.Trim().Trim('"').Trim("'")
            if ($clean) { $out += $clean }
        }
    }
    return $out
}

function New-BlogPost {
    $title = $Arg
    if ([string]::IsNullOrWhiteSpace($title)) {
        Write-Bad '缺少标题，例如:  .\blog new "我的新文章"'
        return
    }
    $title = $title.Trim()

    $slugValue = $Slug
    if ([string]::IsNullOrWhiteSpace($slugValue)) {
        # 纯英文标题自动生成短名
        if ($title -match '^[\x20-\x7E]+$') {
            $slugValue = ($title.ToLower() -replace '[^a-z0-9]+', '-').Trim('-')
        }
        # 中文标题问一下，直接回车就用日期命名
        if ([string]::IsNullOrWhiteSpace($slugValue)) {
            $slugValue = Read-Host '  网址用的英文短名（回车 = 用日期命名）'
            if ([string]::IsNullOrWhiteSpace($slugValue)) {
                $slugValue = 'post-' + (Get-Date -Format 'yyyyMMdd-HHmm')
            }
        }
    }
    $slugValue = ($slugValue.Trim().ToLower() -replace '[\s/\\]+', '-').Trim('-')

    if (-not (Test-Path $PostsDir)) { New-Item -ItemType Directory -Path $PostsDir | Out-Null }
    $file = Join-Path $PostsDir ($slugValue + '.md')
    if (Test-Path $file) {
        Write-Bad "已经有一篇同名文件了: content/posts/$slugValue.md"
        return
    }

    $now = Get-Date
    $stamp = $now.ToString('yyyy-MM-ddTHH:mm:sszzz')

    $Categories = Split-List $Categories
    $Tags = Split-List $Tags

    $catLine = '[]'
    if ($Categories.Count -gt 0) { $catLine = '[' + (($Categories | ForEach-Object { '"' + $_ + '"' }) -join ', ') + ']' }
    $tagLine = '[]'
    if ($Tags.Count -gt 0) { $tagLine = '[' + (($Tags | ForEach-Object { '"' + $_ + '"' }) -join ', ') + ']' }

    $body = @"
---
title: "$title"
date: $stamp
lastmod: $stamp
draft: true # 写完把 true 改成 false 才会发布到线上

author: ["LFL"]

categories: $catLine # 文章分类

tags: $tagLine # 文章标签

keywords: []

description: "" # 一句话介绍，给搜索引擎看
summary: "" # 留空会自动截取正文开头显示在主页

slug: "$slugValue"
comments: true # 是否启用评论
hideMeta: false # 是否隐藏发布日期等元信息
cover:
    image: ""
    caption: ""
    alt: ""
    relative: false
---

<meta name="referrer" content="no-referrer" />

在这里开始写正文……

<!-- 小提示
     图片：把文件放进 static/，然后 ![说明](/图片名.png)
     代码：三个反引号 + 语言名，会自动带行号和复制按钮
     目录：右侧会自动生成
-->
"@

    [System.IO.File]::WriteAllText($file, $body, (New-Object System.Text.UTF8Encoding($false)))

    Write-Ok "已创建 content/posts/$slugValue.md"
    Write-Host ''
    Write-Host "  标题  $title" -ForegroundColor Gray
    Write-Host "  草稿  draft: true（本地预览能看到，发布前要改成 false）" -ForegroundColor Gray
    Write-Host ''
    $code = Get-Command code -ErrorAction SilentlyContinue
    if ($code) {
        Write-Step '用 VS Code 打开'
        & $code.Source --reuse-window $file
    }
    else {
        Write-Host "  用编辑器打开: $file" -ForegroundColor Gray
    }
}

function Start-BlogPreview {
    if (-not (Test-Hugo)) { return }
    Write-Ok "预览地址 http://localhost:1313/  （按 Ctrl+C 停止）"
    Write-Host '  草稿也会显示，改文件会自动刷新' -ForegroundColor Gray
    Write-Host ''
    & hugo server -D --disableFastRender --noHTTPCache --port 1313
}

function Get-DraftPosts {
    $drafts = @()
    if (-not (Test-Path $PostsDir)) { return $drafts }
    Get-ChildItem $PostsDir -Filter *.md | ForEach-Object {
        if (Select-String -Path $_.FullName -Pattern '^\s*draft:\s*true' -Quiet -ErrorAction SilentlyContinue) {
            $drafts += $_.Name
        }
    }
    return $drafts
}

function Invoke-BlogDeploy {
    if (-not (Test-Path (Join-Path $Root '.git'))) {
        Write-Bad '当前目录不是 git 仓库'
        return
    }

    $branch = Get-CurrentBranch
    if ($branch -ne 'main') {
        Write-Bad "当前分支是 '$branch'，GitHub Actions 只在 main 上部署。先 git switch main 再来。"
        return
    }

    # 1) 本地构建校验 —— 提前发现报错，避免推上去 CI 挂掉
    if (-not $NoBuild -and (Test-Hugo)) {
        Write-Step '本地构建校验'
        & hugo --gc --minify --cleanDestinationDir
        if ($LASTEXITCODE -ne 0) {
            Write-Bad '构建失败，已中止，什么都没提交。'
            return
        }
        Write-Ok '构建通过'
    }

    # 2) 草稿提醒
    $drafts = Get-DraftPosts
    if ($drafts.Count -gt 0) {
        Write-Warn2 ('以下草稿不会被发布: ' + ($drafts -join ', '))
    }

    # 3) 提交（没有改动也没关系，接着往下走 —— 可能只是有提交还没推）
    Write-Step '提交改动'
    & git add -A
    if ($LASTEXITCODE -ne 0) { Write-Bad 'git add 失败'; return }

    & git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
        Write-Warn2 '没有新的改动需要提交'
    }
    else {
        $message = $Arg
        if ([string]::IsNullOrWhiteSpace($message)) {
            $message = '更新博客 ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')
        }
        & git commit -m $message
        if ($LASTEXITCODE -ne 0) { Write-Bad 'git commit 失败'; return }
        Write-Ok "已提交: $message"
    }

    # 4) 同步远端（只有远端真的多了提交才需要 pull，否则这一步是纯浪费网络）
    if ($SkipPull) {
        Write-Warn2 '按 -SkipPull 要求，不同步远端'
    }
    else {
        $behindRaw = (& git rev-list --count 'HEAD..origin/main' 2>$null)
        $behind = $null
        if ($LASTEXITCODE -eq 0 -and "$behindRaw".Trim() -match '^\d+$') { $behind = [int]"$behindRaw".Trim() }

        if ($behind -eq 0) {
            Write-Ok '远端没有新提交，跳过 pull'
        }
        else {
            if ($behind -ne $null) { Write-Step "同步远端 main（落后 $behind 个提交）" }
            else { Write-Step '同步远端 main' }

            $pull = Invoke-Git-Net @('pull', '--rebase', '--autostash', 'origin', 'main')
            if ($pull.Text) { Write-Host $pull.Text -ForegroundColor Gray }
            if ($pull.Code -ne 0) {
                if (Test-NetworkError $pull.Text) {
                    Write-Bad '连不上 GitHub —— 网络/代理问题，不是代码冲突'
                    Show-ProxyTip -Text $pull.Text
                }
                else {
                    Write-Bad 'git pull --rebase 失败，可能真的有冲突；解决后重跑，或用 -SkipPull 跳过'
                }
                return
            }
            Write-Ok '已同步远端'
        }
    }

    # 5) 推送
    if ($NoPush) {
        Write-Warn2 '按 -NoPush 要求，只提交没有推送'
        return
    }
    $aheadRaw = (& git rev-list --count 'origin/main..HEAD' 2>$null)
    $ahead = ''
    if ($LASTEXITCODE -eq 0 -and "$aheadRaw".Trim() -match '^\d+$') { $ahead = "（$("$aheadRaw".Trim()) 个提交待推送）" }

    Write-Step "推送到 GitHub$ahead"
    $push = Invoke-Git-Net @('push', 'origin', 'main')
    if ($push.Text) { Write-Host $push.Text -ForegroundColor Gray }
    if ($push.Code -ne 0) {
        if (Test-NetworkError $push.Text) {
            Write-Bad '连不上 GitHub —— 网络/代理问题，不是代码问题'
            Show-ProxyTip -Text $push.Text
        }
        elseif ($push.Text -match 'rejected|non-fast-forward|fetch first') {
            Write-Bad '推送被拒：远端有你的本地没有的提交。去掉 -SkipPull 重跑一次，先同步再推'
        }
        else {
            Write-Bad 'git push 失败，看上面 git 的原话'
        }
        return
    }

    Write-Host ''
    Write-Ok '推送完成，GitHub Actions 大约 1 分钟内部署上线'
    Write-Host "  构建进度  $ActionsUrl" -ForegroundColor Gray
    Write-Host "  线上站点  $SiteUrl" -ForegroundColor Gray
    Write-Host ''
}

switch ($Action) {
    'new' { New-BlogPost }
    'preview' { Start-BlogPreview }
    'deploy' { Invoke-BlogDeploy }
    default { Show-Help }
}
