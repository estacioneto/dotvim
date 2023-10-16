-- Options
vim.g.coc_global_extensions = {
  'coc-tsserver',
  'coc-eslint',
  'coc-css',
  'coc-json',
  'coc-highlight',
  'coc-snippets'
}

vim.g.coc_disable_transparent_cursor = 1

-- Coc statusline
vim.cmd([[ autocmd User CocStatusChange :lua require('lualine').refresh() ]])

-- Highlight
-- vim.cmd([[
-- hi CocSearch ctermfg=12 guifg=#18A3FF
-- hi CocMenuSel ctermbg=109 guibg=#13354A
-- ]])


-- Mappings
local silent = { silent = true }

-- Remap keys for gotos
vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', silent)
vim.keymap.set('n', 'gt', '<Plug>(coc-type-definition)', silent)
vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', silent)
vim.keymap.set('n', 'gr', '<Plug>(coc-references)', silent)
vim.keymap.set('n', '<leader>rn', '<Plug>(coc-rename)', silent)
vim.keymap.set('n', '<leader>re', '<Plug>(coc-refactor)', silent)

-- Use `[c` and `]c` to navigate diagnostics
vim.keymap.set('n', '[c', '<Plug>(coc-diagnostic-prev)<CR>zz', silent)
vim.keymap.set('n', ']c', '<Plug>(coc-diagnostic-next)<CR>zz', silent)
vim.keymap.set('n', '<leader>D', function () vim.cmd('copen') end, silent)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice.
vim.keymap.set('i', '<silent><cr>', [[coc#pum#visible() ? coc#pum#confirm() : \<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>]], { noremap = true, expr = true })

-- Use <c-j> to trigger snippets
vim.keymap.set('i', '<c-j>', '<Plug>(coc-snippets-expand-jump)')
-- Use <c-space> to trigger completion
vim.keymap.set('i', '<c-space>', 'coc#refresh()', { silent = true, expr = true })

-- Use K to show documentation in preview window
local function show_docs()
  local cw = vim.fn.expand('<cword>')
  if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
    vim.api.nvim_command('h ' .. cw)
  elseif vim.api.nvim_eval('coc#rpc#ready()') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
  end
end

vim.keymap.set('n', 'K', show_docs, silent)

-- Imports
vim.keymap.set('n', '<leader>oi', function () vim.fn.CocActionAsync('organizeImport') end)

-- TypeScript
vim.keymap.set('n', '<leader>T', function () vim.fn.CocActionAsync('runCommand', 'tsserver.watchBuild') end)

-- ESLint
vim.keymap.set('n', '<leader>ee', function () vim.fn.CocActionAsync('runCommand', 'eslint.executeAutofix') end)
vim.keymap.set('n', '<leader>ea', function ()
  vim.fn.CocAction('organizeImport')
  vim.fn.CocActionAsync('runCommand', 'eslint.executeAutofix')
end)

vim.keymap.set('n', '<leader>cs', ':CocSearch ')
