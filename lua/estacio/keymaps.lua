-- let g:mapleader = ','
-- vim.g.mapleader = ','
vim.g.mapleader = ' '

-- Regexp to replace string mappings:
--   s/^vim.keymap.set('\(.\)', '\(.\+\)', ['"]\(.\+\)['"])$/\1map \2 \3/g
--
-- Silent/Unique:
--   s/^vim.keymap.set('\(.\)', '\(.\+\)', ['"]\(.\+\)['"], { \(\(.\+\) = true\) })$/\1map <\5> \2 \3

-- Insert mode
vim.keymap.set('i', 'jk', '<esc>')

-- Movement
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv")
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

-- Tab switching
vim.keymap.set('n', '<c-t><c-n>', vim.cmd.tabnew, { silent = true })
vim.keymap.set('n', '<c-t><c-l>', vim.cmd.tabnext, { silent = true })
vim.keymap.set('n', '<c-t><c-h>', vim.cmd.tabprevious, { silent = true })

-- Buffer switching
vim.keymap.set('n', '<s-l>', vim.cmd.bnext, { silent = true })
vim.keymap.set('n', '<s-h>', vim.cmd.bprevious, { silent = true })

-- Close all buffers except current one
vim.keymap.set('n', '<leader>qo', function() vim.cmd("execute '%bdelete|edit#|bdelete#'") end)

-- Copy file path
vim.keymap.set('n', 'cpr', function() vim.cmd('let @+ = expand("%")') end, { silent = true })
vim.keymap.set('n', 'cpf', function() vim.cmd('let @+ = expand("%:p")') end, { silent = true })
-- Copy file directory
vim.keymap.set('n', 'cdr', function() vim.cmd('let @+ = expand("%:h")') end, { silent = true })
vim.keymap.set('n', 'cdf', function() vim.cmd('let @+ = expand("%:p:h")') end, { silent = true })

-- Jump to previous file
vim.keymap.set('n', '<c-p>', '<c-^>', { silent = true })

-- Terminal
vim.keymap.set('t', 'jk', '<c-\\><c-n>')

-- Quickfix
vim.keymap.set('n', '<leader>D', function () vim.cmd('copen') end, { silent = true })

-- Open URL
vim.keymap.set('n', 'gx', function()
  local uri = vim.fn.expand('<cWORD>')
  uri = vim.fn.substitute(uri, '?', '\\?', '')
  uri = vim.fn.shellescape(uri, 1)

  if uri ~= '' then
    os.execute('open '..uri)
    vim.cmd.redraw()
  end
end)

-- Netrw
-- Avoid ctrl-l to refresh netrw
if vim.fn.hasmapto('<Plug>NetrwRefresh') == 0 then
  vim.keymap.set('n', '<c-n>', '<Plug>NetrwRefresh', { unique = true })
end

-- Custom exporer for specific scenarios
local function MyExplore(command)
  if vim.fn.winnr('$') == 1 then
    vim.g.netrw_browse_split = 0
  else
    vim.g.netrw_browse_split = 4
  end

  vim.cmd(command)
end

vim.keymap.set('n', '<leader>ef', function() MyExplore("Lexplore %:p:h") end)
vim.keymap.set('n', '<leader>ed', function() MyExplore("Lexplore") end)
vim.keymap.set('n', '<leader>E', function() MyExplore("Explore") end)

-- New file
-- Current directory
vim.keymap.set('n', '<leader>nf', ':e %:h/')

-- Delete current file
vim.keymap.set('n', '<leader>df', function()
  local path = vim.fn.expand('%')

  vim.cmd(string.format('call delete(%q)', path))
  vim.print(path..' deleted!')
end)
