vim.keymap.set('n', '<leader>sg', function()
  local pattern = vim.fn.input('Pattern: ', '')

  vim.cmd('silent! grep! '..pattern)
  vim.cmd[[copen]]
end)

-- Use fzf.vim or telescope depending on the initialization
if not string.find(vim.fn.getcwd(), '/clients') then
  require('estacio.files.telescope')
else
  require('estacio.files.fzf')
end

-- Independently, I'll use fzf because telescope is not fast enough for fuzzy search and files in a whole repo like klarna-app one.

vim.cmd[[
command! -bang -nargs=? -complete=dir GFiles
\ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}))

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}))

command! -bang -nargs=* GitRg
\ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'dir': system('git -C '.expand('%:p:h').' rev-parse --show-toplevel 2> /dev/null')[:-2]}, <bang>0)
]]

vim.keymap.set('n', '<leader>gr', function() vim.cmd('GFiles && git ls-files -o--exclude-standard') end)

vim.keymap.set('n', '<leader>fr', vim.cmd.Files)

vim.keymap.set('n', '<leader>sd', vim.cmd.Rg)
vim.keymap.set('n', '<leader>sr', vim.cmd.GitRg)
