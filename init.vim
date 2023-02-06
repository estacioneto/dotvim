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

Plug 'neoclide/coc.nvim', { 'branch': 'release', 'do': 'yarn install' }
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/jsonc.vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
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

" Dap
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'
"Plug 'tpope/vim-vinegar'

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
" set completeopt+=noinsert
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
set sessionoptions+=globals

" Netrw options

let g:netrw_preview = 1
let g:netrw_altv = 1
" Default to tree mode
let g:netrw_liststyle=3

" Hide netrw banner
" let g:netrw_banner = 0
let g:netrw_winsize = 30
let g:netrw_localcopydircmd = 'cp -r'

" CoC option
let g:coc_disable_transparent_cursor = 1

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
nmap <silent> rn <Plug>(coc-rename)
nmap <silent><leader>re <Plug>(coc-refactor)

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nnoremap <silent><leader>D :copen<cr>

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

 
" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" remap for complete to use tab and <cr>
inoremap <silent><expr> <c-space> coc#refresh()

hi CocSearch ctermfg=12 guifg=#18A3FF
hi CocMenuSel ctermbg=109 guibg=#13354A

nnoremap <silent> <leader>ee :CocCommand eslint.executeAutofix<cr>

"""}}}2

" Fugitive
nnoremap <silent> <leader>c :Gcommit<cr>
nnoremap <silent> <leader>s :Gstatus<cr>

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}))

command! -bang -nargs=? -complete=dir FilesPwd
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'dir': getcwd()}))

command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}))

command! -bang -nargs=? -complete=dir GFilesPwd
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview({'dir': getcwd()}))

command! -bang -nargs=? -complete=dir GFilesPwdT
  \ call fzf#vim#gitfiles(<q-args>, {'dir': getcwd()})

command! -bang -nargs=? GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" Close all buffers except current one
command! BufCurOnly execute '%bdelete|edit#|bdelete#'
nnoremap <leader>qo :BufCurOnly<cr>

command! -nargs=0 Tsc :call CocAction('runCommand', 'tsserver.watchBuild')
nnoremap <leader>T :Tsc<cr>

" Fuzzy finder
nnoremap <leader>gr :GFiles && git ls-files -o --exclude-standard<cr>
nnoremap <leader>gd :GFilesPwd && git ls-files -o --exclude-standard<cr>

nnoremap <leader>fr :Files<cr>
nnoremap <leader>fd :FilesPwd<cr>

" Terminal
tnoremap jk <c-\><c-n>

" Formatters
vnoremap <leader>fg :!prettier --stdin --stdin-filepath query.gql<cr>
vnoremap <leader>fj :!prettier --stdin --stdin-filepath module.js<cr>
vnoremap <leader>fm :!fmt -80 -s<cr>

nnoremap <leader>p :Prettier<cr>
nnoremap <leader>s :Rg<cr>
nnoremap <leader>gg :GGrep<cr>

" Insert mode
inoremap jk <esc>

" Copy file path
nmap cpr :let @+ = expand("%")<cr>
nmap cpf :let @+ = expand("%:p")<cr>

" Netrw
" Avoid ctrl-l to refresh netrw
if !hasmapto('<Plug>NetrwRefresh')
  nmap <unique> <c-n> <Plug>NetrwRefresh
endif
" Open sidebar
nnoremap <leader>ef :call MyExplore("Lexplore %:p:h")<CR>
nnoremap <leader>ed :call MyExplore("Lexplore")<CR>
nnoremap <leader>E :call MyExplore("Explore")<CR>

" Dap (Debugging)
nnoremap <leader>db :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <leader>do :lua require'dap'.step_out()<CR>
nnoremap <leader>di :lua require'dap'.step_into()<CR>
nnoremap <leader>dn :lua require'dap'.step_over()<CR>
nnoremap <leader>ds :lua require'dap'.stop()<CR>
nnoremap <leader>dc :lua require'dap'.continue()<CR>
nnoremap <leader>du :lua require'dap'.up()<CR>
nnoremap <leader>dj :lua require'dap'.down()<CR>
nnoremap <leader>d_ :lua require'dap'.disconnect();require'dap'.stop();require'dap'.run_last()<CR>
nnoremap <leader>dr :lua require'dap'.repl.open({}, 'vsplit')<CR><C-w>l
nnoremap <leader>di :lua require'dap.ui.variables'.hover()<CR>
vnoremap <leader>dvi :lua require'dap.ui.variables'.visual_hover()<CR>
nnoremap <leader>d? :lua require'dap.ui.variables'.scopes()<CR>
nnoremap <leader>de :lua require'dap'.set_exception_breakpoints({"all"})<CR>
nnoremap <leader>da :lua require'debugHelper'.attach()<CR>
nnoremap <leader>dA :lua require'debugHelper'.attachToRemote()<CR>
nnoremap <leader>dk :lua require'dap.ui.widgets'.hover()<CR>
nnoremap <leader>d? :lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>
" Telescope dap
nnoremap <leader>dtf :Telescope dap frames<CR>
nnoremap <leader>dtc :Telescope dap commands<CR>
nnoremap <leader>dtlb :Telescope dap list_breakpoints<CR>
" Dap UI
" Plug 'rcarriga/nvim-dap-ui'
nnoremap <leader>dui :lua require("dapui").toggle()<CR>

command! WQ wq
command! Wq wq
command! W w
command! Q BufCurOnly

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

" theHamsta/nvim-dap-virtual-text and mfussenegger/nvim-dap
let g:dap_virtual_text = v:true

lua << EOLUA
-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "typescript", "tsx", "javascript", "graphql" },

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

-- nvim-dap
local dap = require('dap')
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/.nvim/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
}
dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to remote',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
    address = "127.0.0.1",
    port = 9229,
    protocol = 'inspector'
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

vim.fn.sign_define('DapBreakpoint', {text='✋', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='👉', texthl='', linehl='', numhl=''})

-- Telescope
require('telescope').setup()
require('telescope').load_extension('dap')

-- Dap UI

require("dapui").setup()

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
endfunction

function MyExplore(command)
  if winnr('$') == 1
    let g:netrw_browse_split = 0
    :execute a:command
  else
    let g:netrw_browse_split = 4
    :execute a:command
  endif
endfunction

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
  if has('gui_running')
    set background=light
  else
    set background=dark
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

let g:solarized_termcolors=256

" See https://gist.github.com/ryanflorence/1381526
function RandomColorSchemeMyPicks()
  let mypicks = ['codedark', 'material']
  let mypick = mypicks[localtime() % len(mypicks)]
  let my_material_themes = ['defautl', 'ocean', 'palenight', 'darker']

  let g:material_theme_style = my_material_themes[localtime() % len(my_material_themes)]

  echom mypick
  execute 'colo' mypick
endfunction

command NewColor call RandomColorSchemeMyPicks()
call RandomColorSchemeMyPicks()

"""}}}1

