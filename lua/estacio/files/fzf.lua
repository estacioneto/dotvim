-- TODO: Maybe add these colors to bat
vim.cmd[[
let g:fzf_colors =
\ { 'fg': ['fg', 'Normal'],
\ 'bg': ['bg', 'Normal'],
\ 'preview-fg': ['fg', 'Normal'],
\ 'preview-bg': ['bg', 'Normal'],
\ 'hl': ['fg', 'Comment'],
\ 'fg+': ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\ 'bg+': ['bg', 'CursorLine', 'CursorColumn'],
\ 'hl+': ['fg', 'Statement'],
\ 'info': ['fg', 'PreProc'],
\ 'border': ['fg', 'Ignore'],
\ 'prompt': ['fg', 'Conditional'],
\ 'pointer':['fg', 'Exception'],
\ 'marker': ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header': ['fg', 'Comment'] }

command! -bang -nargs=? -complete=dir GFilesPwd
\ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview({'dir': getcwd()}))

command! -bang -nargs=? -complete=dir FilesPwd
\ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'dir': getcwd()}))

]]

vim.keymap.set('n', '<leader>gd', function() vim.cmd('GFilesPwd && git ls-files -o --exclude-standard') end)

vim.keymap.set('n', '<leader>fd', vim.cmd.FilesPwd)
