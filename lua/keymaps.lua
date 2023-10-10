vim.g.mapleader = ','

-- Insert mode
vim.keymap.set('i', 'jk', '<esc>')

-- Movement
vim.keymap.set('v', 'J :m', "'>+1<cr>gv=gv")
vim.keymap.set('v', 'K :m', "'<-2<cr>gv=gv")
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Safety
vim.keymap.set('n', 'Q', '<nop>')

-- Window switching
vim.keymap.set('n', '<c-h>', '<c-w>h', { silent = true })
vim.keymap.set('n', '<c-j>', '<c-w>j', { silent = true })
vim.keymap.set('n', '<c-k>', '<c-w>k', { silent = true })
vim.keymap.set('n', '<c-l>', '<c-w>l', { silent = true })

-- Buffer switching
vim.keymap.set('n', '<s-l>', vim.cmd.bnext, { silent = true })
vim.keymap.set('n', '<s-h>', vim.cmd.bprevious, { silent = true })

-- Misc
vim.keymap.set('n', '<leader>q', vim.cmd.q, { silent = true })


-- Copy file path
vim.keymap.set('n', 'cpr', function() vim.cmd('let @+ = expand("%")') end, { silent = true })
vim.keymap.set('n', 'cpf', function() vim.cmd('let @+ = expand("%:p")') end, { silent = true })
-- Copy file directory
vim.keymap.set('n', 'cdr', function() vim.cmd('let @+ = expand("%:h")') end, { silent = true })
vim.keymap.set('n', 'cdf', function() vim.cmd('let @+ = expand("%:p:h")') end, { silent = true })

-- Plugins

-- Undo tree
vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle, { silent = true })

-- Search
vim.keymap.set('n', '<leader>s', vim.cmd.Rg)
vim.keymap.set('n', '<leader>gg', vim.cmd.GGrep)

