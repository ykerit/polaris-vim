" common
set nocompatible
set modifiable
set shiftwidth=4 
set tabstop=4 
set softtabstop=4 
set smarttab 
set nu
set noeb vb t_vb=
set syntax=on
set scrolloff=5
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set hidden
let mapleader = ','
set cursorline
set hlsearch
set incsearch
set ignorecase

call plug#begin('~/.vim/plugged')
" 自动对其
Plug 'junegunn/vim-easy-align'
" 文件树
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" 代码检查
Plug 'dense-analysis/ale'
" 文件查找
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
" airlien
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" 主题
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'flazz/vim-colorschemes'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" auto complete
Plug 'Valloric/YouCompleteMe'
Plug 'Raimondi/delimitMate'
Plug 'ctrlpvim/ctrlp.vim' | Plug 'tacahiroy/ctrlp-funky'
Plug 'kien/rainbow_parentheses.vim'
call plug#end()

" ale settting
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '>'
let g:ale_statusline_format = ['x %d','⚠ %d', '⬥ ok']
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_set_highlights = 1
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

" You complete me
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_complete_in_comments = 1  "在注释输入中也能补全
let g:ycm_complete_in_strings = 1   "在字符串输入中也能补全
let g:ycm_use_ultisnips_completer = 1 "提示UltiSnips
let g:ycm_collect_identifiers_from_comments_and_strings = 1   "注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_tags_files = 1
" 开启语法关键字补全
let g:ycm_seed_identifiers_with_syntax=1
" 回车作为选中
let g:ycm_key_list_stop_completion = ['<CR>']


" nerdtree setting
map <C-n> :NERDTreeToggle<CR>
nmap ga <Plug>(EasyAlign)
inoremap jk <esc>:w<cr>
nnoremap H <C-w>h
nnoremap J <C-w>j
nnoremap K <C-w>k
nnoremap L <C-w>l
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
map <leader>tm :tabclose<CR>

" theme
colorscheme dracula
" brackets
inoremap ' ''<ESC>i
inoremap " ""<ESC>i
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { {<CR>}<ESC>O

" cquery
let g:LanguageClient_serverCommands = {
    \ 'cpp': ['cquery', '--log-file=/tmp/cq.log'],
    \ 'c': ['cquery', '--log-file=/tmp/cq.log'],
    \ }

let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
let g:LanguageClient_settingsPath = '/home/YOUR_USERNAME/.config/nvim/settings.json'
set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()

nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

"copy no number
function! HideNumber()
  if(&relativenumber == &number)
    set relativenumber! number!
  elseif(&number)
    set number!
  else
    set relativenumber!
  endif
  set number?
endfunc
nnoremap <F3> :call HideNumber()<CR>
