"编辑环境设置
filetype off	"检测文件类型
if has("syntax")	"开启语法高亮
	syntax on
endif
set nocp	"不以模拟vi方式运行
set number	"显示行号
set cindent	"在C语言中自动缩进
set autoindent	"自动缩进（下一行与当前行缩进一样）
set tabstop=4	"设置tab键为4个空格
set shiftwidth=4	"设置缩进空格数为4
set background=dark "设置背景为黑
set nobackup	"不生成备份文件
if has('mouse')	"在全模式下使用鼠标
  set mouse=a
endif
set incsearch	"快速查找
set hlsearch	"高亮搜索字
set scrolloff=100	"保持与上下10行的间距
set showcmd	"显示输入的命令
set cursorline	"高亮所在行
set cursorcolumn "高亮所在列

"There are so many times I realized that I don't need taglist when I start
"So I comment out the following two lines, if you want to open a taglist
"just type :TlistOpen
"let Tlist_Auto_Open = 1	"自动打开TlistToggle
"let Tlist_Exit_OnlyWindow = 1	"当只剩Tlist窗口则自动退出

set undodir=~/.vim/undodir	"持久性undo in version7.3
set undofile
set undolevels=1000 "可被undo的次数
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

"colorscheme molokai
colorscheme solarized
set t_Co=256

"一些自动命令
if has("autocmd")	"让光标指向上次编辑的位置
   autocmd BufRead *.txt set tw=78
   autocmd BufReadPost *
	 \ if line("'\"") > 0 && line ("'\"") <= line("$") |
	 \   exe "normal g'\"" |
	 \ endif
endif

autocmd filetype lisp,scheme,art,clojure setlocal equalprg=indent.lisp

"运行自动命令
augroup Program
	autocmd BufNewFile *.html 0r ~/Templates/html
	autocmd BufNewFile *.py 0r ~/Templates/python
	autocmd BufNewFile *.c 0r ~/Templates/c
augroup END

nmap <leader>md :%!md2html --html4tags <cr>
au BufRead,BufNewFile *.md set filetype=markdown "设置后缀名为md的文件为markdown文件
au BufRead,BufNewFile *.clj set filetype=clojure "设置后缀名为clj的文件为clojure文件

map j gj
map k gk
map ; :
map <Up> g<Up>
map <Down> g<Down>
imap <Up> <Esc>g<Up>a
imap <Down> <Esc>g<Down>a


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
" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'git://github.com/Lokaltog/powerline.git'
Bundle 'stephenmckinney/vim-solarized-powerline'
" ...

filetype plugin indent on     " required!
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
