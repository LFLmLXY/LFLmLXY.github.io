---
title: "Neovim的基本配置"
date: 2025-05-02T10:43:08+08:00
lastmod: 2025-05-02T10:43:08+08:00
draft: false # 是否为草稿
author: ["LFL"] #文章作者

categories: ["Nvim配置"] #文章分类

tags: ["neovim"] #文章标签

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

## 简介

**Neovim** 是一个旨在积极重构Vim的项目，目的是简化维护、鼓励贡献、在多个开发人员之间拆分工作、启用高级用户界面以及最大化可扩展性。它是Vim的升级版，加入了许多Vim还没有实现的功能，因此被认为是一个更现代、更强大的文本编辑器。

## Nvim 配置基础知识

### 配置文件路径

**`Nvim` 的配置目录在 `~/.config/nvim` 下。在 Linux/Mac 系统上，`Nvim` 会默认读取 `~/.config/nvim/init.lua` 文件，在Windows系统上`Nvim` 会默认读取 `%USERPROFILE%/AppData/Local/nvim/init.lua` 文件**理论上**来说可以将所有配置的东西都放在这个文件里面，但这样不是一个好的做法，因此我划分不同的文件和目录来分管不同的配置**

```text
.
│  init.lua
│  lazy-lock.json
│
└─lua
    ├─core
    │      keymaps.lua
    │      options.lua
    │
    └─plugins
            bufferline.lua
            colorscheme.lua
            lsp.lua
            neo-tree.lua
            plugins-setup.lua
            toggleterm.lua
```

### 解释如下

* `init.lua` 为 `Nvim` 配置的 Entry point，我们主要**用来导入其他 `\*.lua` 文件**
  * `core` 核心配置
    * `options.lua` 配置选项功能
    * `keymaps.lua` 配置按键映射
  * `plugins` 插件包
    * `plugins-setup.lua` 插件配置
* `lua` 目录。当我们在 Lua 里面调用 `require` 加载模块（文件）的时候，它会自动在 `lua` 文件夹里面进行搜索
  * *将路径分隔符从 `/` 替换为 `.`，然后去掉 `.lua` 后缀就得到了 `require` 的参数格式*

### 选项配置

主要用到的就是 `vim.g`、`vim.opt`、`vim.cmd` 等

| ln`Vim`           | ln`Nvim`                  | Note                           |
| ----------------- | ------------------------- | ------------------------------ |
| `let g:foo = bar` | `vim.g.foo = bar`         |                                |
| `set foo = bar`   | `vim.opt.foo = bar`       | `set foo = vim.opt.foo = true` |
| `some_vimscript`  | `vim.cmd(some_vimscript)` |                                |

### 按键配置

在 `Nvim` 里面进行按键绑定的语法如下

```lua
vim.keymap.set(<mode>, <key>, <action>, <opts>)
```

* `mode ` 指模式,命令模式`n`插入模式`i`可视模式`v`终端模式`t`
* `key` 要绑定的按键
* `action` 对应的按键，也可以是函数、三目运算符
* `opts` 选项，默认全为`false`
  * `buffer` `(bool or number) `从给定缓冲区中删除映射，当 `0` 或 `true` 时，使用当前缓冲区。
  * `noremap` `(bool)`  非递归模式，仅映射到按键功能，不会向下递归映射。
  * `remap`  `(bool)` 递归模式，若按键功能映射到别的按键，则会向下递归映射。
  * `expr`  `(bool) `表达式映射，即右边的命令是一个表达式，它会返回一个字符串作为实际执行的命令
  * `nowait` `(bool) `不等待用户输入，即在按下映射的第一个键后立即执行。
  * `script` `(bool)` 脚本局部映射，即只在当前脚本中有效。
  * `silent` `(bool)` 不显示命令行，即不打印右边的命令。
  * `unique` `(bool)` 唯一映射，即如果已经存在相同的映射，那么会报错。

## 开始配置 Nvim

### 安装 Nvim

去[官网](https://neovim.io/)安装即可，这里没什么难度<br>安装完成之后去找`%USERPROFILE%/AppData/Local/nvim`没有就创建`nvim`文件夹和`init.lua`文件

### 选项配置

新建 `~/.config/nvim/lua/core/options.lua` 文件并加入如下内容

```lua
vim.opt.clipboard = 'unnamedplus' -- use system clipboard
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.mouse = 'a' -- allow the mouse to be used in Nvim

-- Tab
vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.softtabstop = 4 -- number of spacesin tab when editing
vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
vim.opt.number = true -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
-- vim.opt.termguicolors = true        -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = false -- do not highlight matches
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered

```

然后打开 `init.lua`，用 `require` 导入刚才写的 `options.lua` 文件

```lua
require('core.options')
```

### 按键配置

新建 `~/.config/nvim/lua/core/keymaps.lua` 文件并放入如下内容

```lua
-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}
-- set primary key
vim.g.mapleader = " "

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- delete
vim.keymap.set('n', 'd', '"_d', opts)
vim.keymap.set('n', 'D', '"_D', opts)
vim.keymap.set('n', 'dd', '"_dd', opts)

-- file tab
vim.keymap.set('n', 'L', '<Cmd>bn<CR>')
vim.keymap.set('n', 'H', '<Cmd>bp<CR>')

-- neo-tree
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree reveal<CR>', opts)

-- close buffer
vim.keymap.set('n', 't', '<Cmd>bd<CR>', opts)

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-----------------
-- Insert mode --
-----------------

vim.keymap.set('i', 'jk', '<ESC>', opts)


-----------------
-- Terminal mode --
-----------------
-- ToggleTerm
vim.keymap.set("t", "jk", "<C-\\><C-n>", {noremap = true, silent = true})
vim.keymap.set("t", "<C-l>", "<Cmd> wincmd l<CR>", {noremap = true, silent = true})
vim.keymap.set("t", "<C-h>", "<Cmd> wincmd h<CR>", {noremap = true, silent = true})
vim.keymap.set("t", "<C-j>", "<Cmd> wincmd j<CR>", {noremap = true, silent = true})
vim.keymap.set("t", "<C-k>", "<Cmd> wincmd k<CR>", {noremap = true, silent = true})
```

然后在 `init.lua` 文件里面再次加上一行导入这个文件

```lua
require('core.keymaps')
```

### 插件管理器

一个强大的 `Nvim` 离不开插件的支持。是当下最为流行 [lazy.nvim](https://github.com/folke/lazy.nvim)。

新建 `~/.config/nvim/lua/plugins/plugins-setup.lua` 文件并放入如下内容。

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({})
```

安装其他插件，只需要在`require("lazy").setup({...})`的`...`中声明即可

然后在 `init.lua` 文件里面再次加上一行导入这个文件

```lua
require('plugins.plugins-setup')
```

此时你重启 `Nvim` 会发现黑屏没显示，这是因为 `lazy.nvim` 在安装自己，静待片刻即可。等待 Dashboard 出现之后，可以输入 `:Lazy` 试试，如果看到了弹出了 `lazy.nvim` 的窗口，那就安装成功了

### 主题配置

主题用的是[catppuccin](https://github.com/catppuccin/nvim),在`plugins-setup`添加插件

```lua
require("lazy").setup({
	-- colorscheme manager
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
})

```

保存更改并*重启*就可以看到 `lazy.nvim` 在帮我们安装插件了，新建并编辑 `~/.config/nvim/lua/colorscheme.lua` 文件

```lua
require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
```

最后在 `init.lua` 文件里面导入就行

```lua
require('plugins.colorscheme')
```

### 自动补全

使用 [blink.cmp](https://github.com/saghen/blink.cmp) 插件，*配置会比较简单而且自动补全特别快*

在 `plugins.lua`里新增这个插件并做好配置

```lua
... -- 省略其他行
require("lazy").setup({
    ... -- 省略其他行
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets" },

        -- use a release tag to download pre-built binaries
        version = "*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                -- Each keymap may be a list of commands and/or functions
                preset = "enter",
                -- Select completions
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                -- Scroll documentation
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                -- Show/hide signature
                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            sources = {
                -- `lsp`, `buffer`, `snippets`, `path` and `omni` are built-in
                -- so you don't need to define them in `sources.providers`
                default = { "lsp", "path", "snippets", "buffer" },

                -- Sources are configured via the sources.providers table
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
            completion = {
                -- The keyword should only matchh against the text before
                keyword = { range = "prefix" },
                menu = {
                    -- Use treesitter to highlight the label text for the given list of sources
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                -- Show completions after tying a trigger character, defined by the source
                trigger = { show_on_trigger_character = true },
                documentation = {
                    -- Show documentation automatically
                    auto_show = true,
                },
            },

            -- Signature help when tying
            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    }
})
```

关注其中的 `opts` 配置选项即可，关键的几个*解释如下*

- kyemap -用于配置按键映射，格式也很好理解
  - `preset = "enter"` 表示用 `回车键` 确定当前选中的补全项
  - `select_prev, select_next` 用于在各个候选项中进行选择，我这里配置了 2 套按键，支持用⬆️/⬇️，或者用 Tab/Shift-Tab 进行补全项的选择
  - `scroll_documentation_up, scroll_documentation_down` 用于滚动 API 的文档，我配置的是 `Ctrl-b, Ctrl-f`
- `trigger = { show_on_trigger_character = true }` - 输入字符之后就会展示所有可用补全项
- `documentation = { auto_show = true }` - 自动显示当前被选中补全项的文档

### LSP配置

要把 `Nvim` 变成 IDE 就势必要借助于 LSP[3](https://martinlwx.github.io/zh-cn/config-neovim-from-scratch/#fn:3)，自己安装和配置 LSP 是比较繁琐的。不同的 LSP 安装方法不同，也不方便后续管理。[mason.nvim](https://github.com/williamboman/mason.nvim) 和配套的 [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) 这两个插件很好解决了这个问题<br>首先修改 `plugins.lua` 文件，增加对应的插件

```lua
... -- 省略其他行
require("lazy").setup({
	-- LSP manager
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
    ... -- 省略其他行
})
```

新建一个 `~/.config/nvim/lua/plugins/lsp.lua` 文件并编辑，首先配置 `mason` 和 `mason-lspconfig`

```lua
require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require('mason-lspconfig').setup({
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = { 'pylsp', 'lua_ls'},
})
```

> 我们想要用什么语言的 LSP 就在 `ensure_installed` 里面加上，完整的列表可以看 [server_configurations](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)。

> 每个 LSP 都存在自己可以配置的选项，你可以自己去对应 LSP 的 GitHub 仓库查阅更多信息。如果要用默认配置的话，基本上每一个新的语言都只需要设置 `on_attach = on_attach`

> 配置好 `mason-lspconfig` 之后，接下来就可以配置 `nvim-lspconfig` 了。因为配置的代码比较长，下面只展示了 `pylsp`和`lua_ls` 的配置，其他语言的配置大同小异。如果有疑惑，可以查看该文件的[最新版本](https://github.com/MartinLwx/dotfiles/blob/main/nvim/lua/lsp.lua)

编辑 `~/.config/nvim/lua/plugins/lsp.lua` 文件新增如下内容

```lua
-- Note: The order matters: require("mason") -> require("mason-lspconfig") -> require("lspconfig")

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	-- A list of servers to automatically install if they're not already installed.
	ensure_installed = { "pylsp", "lua_ls"},
})

-- Set different settings for different languages' LSP.
-- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
--     - the settings table is sent to the LSP.
--     - on_attach: a lua callback function to run after LSP attaches to a given buffer.
local lspconfig = require("lspconfig")

-- Customized on_attach function.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions.
local opts = { noremap = true, silent = true }
-- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer.
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	if client.name == "rust_analyzer" then
		-- WARNING: This feature requires Neovim v0.10+
		vim.lsp.inlay_hint.enable()
	end

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, bufopts)
end

-- How to add an LSP for a specific programming language?
-- 1. Use `:Mason` to install the corresponding LSP.
-- 2. Add the configuration below. The syntax is `lspconfig.<name>.setup(...)`
-- Hint (find <name> here): https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

lspconfig.pylsp.setup({
    on_attach = on_attach,
})

lspconfig.lua_ls.setup({
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim).
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global.
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files.
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier.
			telemetry = {
				enable = false,
			},
		},
	},
})
```

最后在 `init.lua` 文件里面加上

```lua
require('plugins.lsp')
```

重启 `Nvim` 之后，你应该可以在下面的状态栏看到 `Mason` 正在下载并安装前面我们指定的 LSP（**注意此时不能关闭 `Nvim`**），可以输入 `:Mason` 查看安装进度。在你等待安装的过程中，可以输入 `g?` 查看更多帮助信息了解如何使用 `mason` 插件

### 目录设置

这里使用的是[neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)插件

在 `plugins.lua`里新增这个插件并做好配置

```lua
require("lazy").setup({
... -- 省略其他行
-- neo-tree manager
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for mo      re information
        },
        lazy = false, -- neo-tree will lazily load itself
        ---@module "neo-tree"
        ---@type neotree.Config?
        opts = {
            -- fill any relevant options here
        },
    },
}

```

新建一个 `~/.config/nvim/lua/plugins/neo-tree.lua` 文件，这里我没有加入任何配置，想个性化可以去看看github

```lua
require("neo-tree").setup{}
```

最后在 `init.lua` 文件里面加上

```lua
require('plugins.neo-tree')
```

输入`:Neotree reveal`就可以启动了，如果你前面复制了我的按键，空格+e就可以打开，查看更多用法`?`

### 文件选项卡

使用的是[bufferline](https://github.com/akinsho/bufferline.nvim)插件

在 `plugins.lua`里新增这个插件并做好配置

```lua
require("lazy").setup({
... -- 省略其他行
-- bufferline
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
}
```

新建一个 `~/.config/nvim/lua/plugins/bufferline.lua` 文件

```lua
vim.opt.termguicolors = true
require("bufferline").setup{}
```

最后在 `init.lua` 文件里面加上

```lua
require('plugins.bufferline')
```

### 终端配置

使用的是[ToggleTerm](https://github.com/akinsho/toggleterm.nvim/)插件

在 `plugins.lua`里新增这个插件并做好配置

```lua
require("lazy").setup({
... -- 省略其他行
-- toggleterm
    {'akinsho/toggleterm.nvim', version = "*", config = true},
}
```

新建一个 `~/.config/nvim/lua/plugins/toggleterm.lua` 文件

```lua
require("toggleterm").setup {
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 1,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = 'single',
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}
```

最后在 `init.lua` 文件里面加上

```lua
require('plugins.toggleterm')
```

启动`ctr+\`

## 参考

1. https://martinlwx.github.io/zh-cn/config-neovim-from-scratch/
2. https://www.bilibili.com/video/BV1Td4y1578E/?spm_id_from=333.1387.homepage.video_card.click

