vim.cmd([[
function! CheckTermAndDisableNumber()
  if &buftype ==# "terminal"
    setlocal nonumber norelativenumber
  endif
endfunction

if has('autocmd')
  filetype indent plugin on

  augroup FTOptions
    autocmd!
    autocmd FileType gitcommit setlocal spell
    autocmd FileType nginx setlocal indentexpr= |
          \ setlocal cindent |
          \ setlocal cinkeys-=0#
    autocmd FileType cs setlocal shiftwidth=4 |
          \ setlocal softtabstop=4
  augroup END
  if has('nvim')
    augroup Term
      autocmd!
      autocmd TermOpen * :call CheckTermAndDisableNumber()
      autocmd WinLeave * :call CheckTermAndDisableNumber()
      autocmd WinEnter * :call CheckTermAndDisableNumber()
      autocmd BufEnter * :call CheckTermAndDisableNumber()
      autocmd BufLeave * :call CheckTermAndDisableNumber()
    augroup END
  endif
endif

" Auto-create parent directories (except for URIs "://").
au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif
]])

-- Open image file
vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileReadPre' }, {
  pattern = { '*.png', '*.jpeg', '*.jpg' },
  command = 'OpenImage'
})
