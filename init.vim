" vim: set foldmethod=marker foldlevel=0:

let g:coc_global_extensions = [
  \'coc-tsserver',
  \'coc-eslint',
  \'coc-css',
  \'coc-json',
  \'coc-texlab',
  \'coc-vimtex',
  \'coc-go',
  \'coc-angular'
  \]

""" Section: Packages {{{1

call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', { 'do': 'yarn install --frozen-lockfile' }
Plug 'neoclide/jsonc.vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'
Plug 'lucasecdb/vim-codedark'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'kaicataldo/material.vim'
Plug 'udalov/kotlin-vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'jparise/vim-graphql'
Plug 'chrisbra/vim-commentary'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'leafgarland/typescript-vim'
Plug 'MaxMEllon/vim-jsx-pretty'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

""" }}}1
""" Section: Options {{{1

set langmenu=en_US
let $LANG='en_US'
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set incsearch
set nohlsearch
set foldmethod=indent
set foldopen+=jump
set foldlevel=99
set number relativenumber
set backspace=indent,eol,start
set clipboard=unnamedplus
set scrolloff=3
set splitbelow
set splitright
set cursorline
set mouse=a
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
set completeopt+=noinsert
set nohls
set ignorecase
set updatetime=300

" Better display for messages
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

set laststatus=2

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

""" }}}1

""" Section: Mappings {{{1

let mapleader=','

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
""" Section: CoC {{{2

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

nnoremap <silent> <leader>ee :CocCommand eslint.executeAutofix<cr>

"""}}}2

" Fugitive
nnoremap <silent> <leader>c :Gcommit<cr>
nnoremap <silent> <leader>s :Gstatus<cr>

nnoremap <leader>r :arg 
cnoremap <leader>r :arg 
nnoremap <leader>R :argdo 
cnoremap <leader>R :argdo 

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'options': ['--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']})

command! -bang -nargs=? -complete=dir FilesPwd
  \ call fzf#vim#files(<q-args>, {'options': ['--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}'], 'dir': getcwd()})

command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, {'options': ['--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']})

command! -bang -nargs=? -complete=dir GFilesPwd
  \ call fzf#vim#gitfiles(<q-args>, {'options': ['--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}'], 'dir': getcwd()})

command! -bang -nargs=? GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" Fuzzy finder
nnoremap <leader>t :GFiles && git ls-files -o --exclude-standard<cr>
nnoremap <leader>d :GFilesPwd && git ls-files -o --exclude-standard<cr>

nnoremap <leader>ft :Files<cr>
nnoremap <leader>fd :FilesPwd<cr>

" Terminal
tnoremap jk <c-\><c-n>

" Formatters
vnoremap <leader>fg :!prettier --stdin --stdin-filepath query.gql<cr>
vnoremap <leader>fj :!prettier --stdin --stdin-filepath module.js<cr>
vnoremap <leader>fm :!fmt -80 -s<cr>

nnoremap <leader>p :Prettier<cr>
nnoremap <leader>s :Rg<cr>
nnoremap <leader>g :GGrep<cr>

" Insert mode
inoremap jk <esc>

" Copy file path
nmap cpr :let @+ = expand("%")<cr>
nmap cpf :let @+ = expand("%:p")<cr>

command! WQ wq
command! Wq wq
command! W w
command! Q q

""" }}}1
""" Section: Plugins options {{{1

let g:airline_powerline_fonts=1
let g:airline_theme='bubblegum'
let g:airline_left_sep=''
let g:airline_right_sep=''

let g:ale_completion_enabled=1
let g:ale_virtualtext_cursor=1

let g:javascript_plugin_jsdoc = 1

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_virtualtext_cursor = 1
let g:ale_linters = {
\  'python': ['flake8'],
\  'html': ['eslint'],
\  'typescript': ['eslint', 'tsserver'],
\  'javascript': ['eslint', 'flow', 'flow-language-server'],
\  'graphql': ['gqlint']
\}

lua << EOLUA
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "typescript", "tsx", "javascript" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOLUA

if executable("rg") 
    set grepprg=rg\ --vimgrep 
endif

"""}}}
""" Section: Functions {{{1

function! CheckTermAndDisableNumber()
  if &buftype ==# "terminal"
    setlocal nonumber norelativenumber
  endif
endfunc

"""}}}1
""" Section: Autocommands {{{1

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
  augroup Coc
    autocmd!
    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')
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

"""}}}1
""" Section: Visual {{{1

if has('syntax')
  if !has('syntax_on') && !exists('syntax_manual')
    syntax on
  endif

  if has('gui')
    set linespace=3
    set guioptions-=r
    set guioptions-=L
  endif

  set termguicolors
  let g:material_theme_style = 'ocean'
  let g:material_terminal_italics = 1
  colorscheme material
  let g:lightline = { 'colorscheme': 'material_vim' }

  " Fix italics in Vim
  if !has('nvim')
    let &t_ZH="\e[3m"
    let &t_ZR="\e[23m"
  endif
endif

"""}}}1
