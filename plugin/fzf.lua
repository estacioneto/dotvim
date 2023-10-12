if vim.fn.executable("rg") then
  vim.opt.grepprg = 'rg\\' --vimgrep 
end

vim.keymap.set('n', '<leader>s', vim.cmd.Rg)
vim.keymap.set('n', '<leader>gg', vim.cmd.GGrep)

vim.keymap.set('n', '<leader>gr', function() vim.cmd('GFiles && git ls-files -o--exclude-standard') end)
vim.keymap.set('n', '<leader>gd', function() vim.cmd('GFilesPwd && git ls-files -o --exclude-standard') end)

vim.keymap.set('n', '<leader>fr', vim.cmd.Files)
vim.keymap.set('n', '<leader>fd', vim.cmd.FilesPwd)
