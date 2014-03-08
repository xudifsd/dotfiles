"编辑环境设置
filetype off	"检测文件类型
if has("syntax")	"开启语法高亮
	syntax on
endif
set nocp	"不以模拟vi方式运行
set number	"显示行号
set cindent	"在C语言中自动缩进
set autoindent	"自动缩进（下一行与当前行缩进一样）
set expandtab "使用space代替tab
au fileType java set noexpandtab
set tabstop=4	"设置tab键为4个空格
set shiftwidth=4	"设置缩进空格数为4
set softtabstop=4
set background=light "设置背景
set nobackup	"不生成备份文件
set incsearch	"快速查找
set hlsearch	"高亮搜索字
set scrolloff=100	"保持与上下100行的间距
set showcmd	"显示输入的命令
set cursorline	"高亮所在行
set cursorcolumn "高亮所在列
set ignorecase smartcase
set backspace=indent,eol,start "make backspace work like most other apps
set list!
set list listchars=tab:»·,trail:·

" for when we forget to use sudo to open/edit a file
cmap w!! w !sudo tee % >/dev/null

"There are so many times I realized that I don't need taglist when I start
"So I comment out the following two lines, if you want to open a taglist
"just type :TlistOpen
"let Tlist_Auto_Open = 1	"自动打开TlistToggle
let Tlist_Exit_OnlyWindow = 1	"当只剩Tlist窗口则自动退出

set undodir=~/.vim/undodir	"持久性undo in version7.3
set undofile
set undolevels=1000 "可被undo的次数
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

"colorscheme molokai
colorscheme solarized
"colorscheme peachpuff
set t_Co=256

"一些自动命令
if has("autocmd")	"让光标指向上次编辑的位置
   autocmd BufRead *.txt set tw=78
   autocmd BufReadPost *
	 \ if line("'\"") > 0 && line ("'\"") <= line("$") |
	 \   exe "normal g'\"" |
	 \ endif
endif

autocmd filetype lisp,scheme,art setlocal equalprg=indent.lisp

"运行自动命令
augroup Program
	autocmd BufNewFile *.html 0r ~/Templates/html
	autocmd BufNewFile *.py 0r ~/Templates/python
	autocmd BufNewFile *.c 0r ~/Templates/c
	autocmd BufNewFile *.java 0r ~/Templates/java
	autocmd BufNewFile *.tex 0r ~/Templates/latex
	autocmd BufNewFile *.cjk 0r ~/Templates/latex
augroup END

nmap <leader>md :%!md2html --html4tags <cr>
augroup filetypedetect
	au BufRead,BufNewFile *.md set filetype=markdown
"	au BufRead,BufNewFile *.clj set filetype=clojure
	au BufNewFile,BufRead *.cl set filetype=cool
    au BufNewFile,BufRead *.cjk set filetype=tex
    au BufNewFile,BufRead Vagrantfile set filetype=ruby
augroup END

map ; :
"makes editing chinese easier
map ； :
map <Up> g<Up>
map <Down> g<Down>
imap <Up> <Esc>g<Up>a
imap <Down> <Esc>g<Down>a

"makes it easier when in multi-window
nnoremap <C-h> <C-W><C-h>
nnoremap <C-j> <C-W><C-j>
nnoremap <C-k> <C-W><C-k>
nnoremap <C-l> <C-W><C-l>

nnoremap == :resize +2<CR>
nnoremap -- :resize -2<CR>
nnoremap ++ :vertical resize +2<CR>
nnoremap __ :vertical resize -2<CR>

"always use n for seach afterwards
noremap <silent><expr>n v:searchforward ? "n" : "N"
noremap <silent><expr>N v:searchforward ? "N" : "n"

set splitbelow
set splitright

set rtp+=~/.vim/bundle/vundle/
set rtp+=~/.vim/powerline/bindings/vim
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'tpope/vim-rails.git'
Bundle 'kien/ctrlp.vim'
Bundle 'EasyMotion'
"Bundle 'Valloric/YouCompleteMe'
" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'git://github.com/Lokaltog/powerline.git'
Bundle 'stephenmckinney/vim-solarized-powerline'
Bundle 'https://github.com/terryma/vim-multiple-cursors'
Bundle 'https://github.com/scrooloose/nerdtree'
Bundle 'https://github.com/tpope/vim-surround'
"Bundle 'typedclojure/vim-typedclojure'
"Bundle 'amdt/vim-niji'
" ...

"for nerdTree
map <C-m> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

filetype plugin indent on     " required by vimclojure
let g:vimclojure#ParenRainbow=8
"let vimclojure#ParenRainbowColors = {
"				\ '1': 'guifg=blue',
"				\ '2': 'guifg=purple',
"				\ '3': 'guifg=green',
"				\ '4': 'guifg=brown',
"				\ '5': 'guifg=cyan',
"				\ '6': 'guifg=darkred',
"				\ '7': 'guifg=gray',
"				\ '8': 'guifg=red',
"				\ '9': 'guifg=magenta',
"				\ '10': 'guifg=black',
"				\ }
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..


set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
let g:Powerline_theme='short'
let g:Powerline_colorscheme='solarized256'
set laststatus=2

"for CtrlP
noremap <C-W><C-U> :CtrlPMRU<CR>
nnoremap <C-W>u :CtrlPMRU<CR>

let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|.rvm$'
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1
set pastetoggle=<F4>
