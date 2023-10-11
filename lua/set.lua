vim.opt.langmenu = 'en_US'
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.foldmethod = 'indent'
vim.opt.foldopen:append('jump')
vim.opt.foldlevel = 99

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.backspace = 'indent,eol,start'
vim.opt.clipboard = 'unnamedplus'
vim.opt.scrolloff = 8

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.mouse = 'a'

vim.opt.rtp:append('/usr/local/opt/fzf')
vim.opt.rtp:append('~/.fzf')

-- vim.opt.completeopt+ = 'noinsert'
vim.opt.hls = false
vim.opt.ignorecase = true
vim.opt.updatetime = 300

-- Better display for messages
vim.opt.cmdheight = 2

-- don't give |ins-completion-menu| messages.
vim.opt.shortmess:append('c')

-- always show signcolumns
vim.opt.signcolumn = 'yes'

vim.opt.laststatus = 2

vim.opt.sessionoptions:append('globals')
