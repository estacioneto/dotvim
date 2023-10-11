-- Coc statusline
table.insert(vim.opt.statusline, "%{coc#status()}%{get(b:,'coc_current_function','')}")
vim.cmd('autocmd User CocStatusChange redrawstatus')
