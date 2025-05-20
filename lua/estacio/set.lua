vim.opt.langmenu = 'en_US'
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.foldmethod = 'indent'
vim.opt.foldopen:append 'jump'
vim.opt.foldlevel = 99

-- See https://github.com/neovim/neovim/issues/20726
vim.cmd [[
autocmd TermOpen * setlocal foldmethod=manual
]]

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.backspace = 'indent,eol,start'
vim.opt.clipboard = 'unnamedplus'
vim.opt.scrolloff = 15

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.mouse = 'a'

vim.opt.rtp:append '/usr/local/opt/fzf'
vim.opt.rtp:append '~/.fzf'

-- vim.opt.completeopt+ = 'noinsert'
vim.opt.hls = false
vim.opt.ignorecase = true
vim.opt.updatetime = 300

-- Better display for messages
vim.opt.cmdheight = 2

-- don't give |ins-completion-menu| messages.
vim.opt.shortmess:append 'c'

-- always show signcolumns
vim.opt.signcolumn = 'yes'
-- vim.opt.colorcolumn = 80

vim.opt.laststatus = 2

vim.opt.sessionoptions:append 'globals'

-- Netrw
vim.g.netrw_preview = 1
vim.g.netrw_altv = 1
-- Default to tree mode
vim.g.netrw_liststyle = 3

-- Hide netrw banner
--  vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30
vim.g.netrw_localcopydircmd = 'cp -r'

-- Vimgrep
vim.opt.grepprg = [[rg --vimgrep ]]

vim.opt.termguicolors = true

-- https://vi.stackexchange.com/questions/31811/neovim-lua-config-how-to-append-to-listchars
vim.opt.listchars:append({ eol = '↵' })
vim.opt.list = false

-- Diff
vim.opt.fillchars = vim.opt.fillchars + 'diff:╱'
