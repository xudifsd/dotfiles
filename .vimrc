"编辑环境设置
filetype on	"检测文件类型
if has("syntax")	"开启语法高亮
	syntax on
endif
set nocp	"不以模拟vi方式运行
set number	"显示行号
set cindent	"在C语言中自动缩进
set autoindent	"自动缩进（下一行与当前行缩进一样）
set tabstop=8	"设置tab键为8个空格
set shiftwidth=8	"设置缩进空格数为8
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

autocmd filetype lisp,scheme,art setlocal equalprg=indent.lisp

"运行自动命令
augroup Program
	autocmd BufNewFile *.html 0r ~/Templates/html
	autocmd BufNewFile *.py 0r ~/Templates/python
	autocmd BufNewFile *.c 0r ~/Templates/c
	autocmd BufNewFile *.h 0r ~/Templates/h
augroup END
