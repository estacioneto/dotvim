" vim: set foldmethod=marker foldlevel=0:

set relativenumber
set nu
syntax on

""" Section: Mappings {{{1

" let mapleader=','
let mapleader=' '

" Window switching
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l

" Buffer switching
nnoremap <silent> <s-l> :bnext<cr>
nnoremap <silent> <s-h> :bprevious<cr>

" Misc
nnoremap <silent> <leader>q :q<cr>
nnoremap <silent> <leader>h :set hidden <bar> close<cr>

" Insert mode
inoremap jk <esc>

command! WQ wq
command! Wq wq
command! W w
command! Q q

""" }}}1
