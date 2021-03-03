scriptencoding utf-8
set encoding=utf-8

filetype off
if has("syntax")
  syntax on
endif
set nocp
set number
set cindent
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set nobackup
set incsearch "quick search
set hlsearch "highlight search
set scrolloff=100
set showcmd
set cursorline "highlight line
set cursorcolumn "highlight column
set smartcase
set backspace=indent,eol,start "make backspace work like most other apps
set list!
set list listchars=tab:»·,trail:·
set tags=tags; "also search tags in parent dir
set pastetoggle=<F4>

" for when we forget to use sudo to open/edit a file
cmap w!! w !sudo tee % >/dev/null

set undodir=~/.vim/undodir "persistent undo in version7.3
set undofile
set undolevels=1000
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

set background=light
set t_Co=256

if has("autocmd") "let cursor pointing to pos of last edit
   autocmd BufRead *.txt set tw=78
   autocmd BufReadPost *
   \ if line("'\"") > 0 && line ("'\"") <= line("$") |
   \   exe "normal g'\"" |
   \ endif
endif

autocmd filetype lisp,scheme,art setlocal equalprg=indent.lisp

augroup Program
    autocmd BufNewFile *.html 0r ~/Templates/html
    autocmd BufNewFile *.py 0r ~/Templates/python
    autocmd BufNewFile *.py :r !echo '\#' `date`
    autocmd BufNewFile *.c 0r ~/Templates/c
    autocmd BufNewFile *.java 0r ~/Templates/java
    autocmd BufNewFile *.tex 0r ~/Templates/latex
    autocmd BufNewFile *.cjk 0r ~/Templates/latex
    autocmd BufNewFile *.erl 0r ~/Templates/erlang
    autocmd BufNewFile *.rs 0r ~/Templates/rust
    autocmd BufNewFile *.rs :0r !echo -e '//' `date`'\n'
augroup END

nmap <leader>md :%!md2html --html4tags <cr>
augroup filetypedetect
    au BufRead,BufNewFile *.md set filetype=markdown
    "au BufRead,BufNewFile *.clj set filetype=clojure
    au BufNewFile,BufRead *.cl set filetype=cool
    au BufNewFile,BufRead *.cjk set filetype=tex
    au BufNewFile,BufRead *.scala set filetype=scala
    au BufNewFile,BufRead Vagrantfile set filetype=ruby
augroup END

map ; :
"makes editing chinese easier
map ； :
map <Up> g<Up>
map <Down> g<Down>
imap <Up> <Esc>g<Up>a
imap <Down> <Esc>g<Down>a

imap <C-a> <Esc>0i
imap <C-e> <Esc>$a
imap <C-1> <Esc>

"makes it easier when in multi-window
nnoremap <C-h> <C-W><C-h>
nnoremap <C-j> <C-W><C-j>
nnoremap <C-k> <C-W><C-k>
nnoremap <C-l> <C-W><C-l>

nnoremap == :resize +2<CR>
nnoremap -- :resize -2<CR>
nnoremap ++ :vertical resize +2<CR>
nnoremap __ :vertical resize -2<CR>

vmap f zf

"always use n for seach afterwards
noremap <silent><expr>n v:searchforward ? "n" : "N"
noremap <silent><expr>N v:searchforward ? "N" : "n"

set splitbelow
set splitright

set nocompatible              " be iMproved, required by vundle
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required!
Plugin 'gmarik/vundle'

Plugin 'kien/ctrlp.vim'
Plugin 'https://github.com/terryma/vim-multiple-cursors'
Plugin 'altercation/vim-colors-solarized'
Plugin 'rust-lang/rust.vim'
Plugin 'wakatime/vim-wakatime'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'https://github.com/nathangrigg/vim-beancount'

" https://github.com/google/vim-codefmt
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" " `:help :Glaive` for usage.
Plugin 'google/vim-glaive'

call vundle#end()            " required
filetype plugin indent on    " required

" for vim airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
nnoremap <C-1> :1b<CR>
nnoremap <C-2> :2b<CR>
nnoremap <C-3> :3b<CR>

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

function! MarkPush()
    if !exists("g:markStack")
        let g:markStack = []
    endif
    call insert(g:markStack, line("."))
endfunction

function! MarkPop()
    if !exists("g:markStack") || len(g:markStack) == 0
        echo "empty stack!"
        return
    endif
    let lineno = g:markStack[0]
    call remove(g:markStack, 0)
    exec 'silent ' . lineno
endfunction

map mm :call MarkPush()<CR>
map 'm :call MarkPop()<CR>

map <C-e> $
map <C-a> 0
nmap <leader>now :r!date<CR>
nmap <leader>c :%y+<CR> " https://stackoverflow.com/a/20912576/845762

filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

"autocmd BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | endif
"autocmd BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | endif

" Transparent editing of gpg encrypted files.
" https://www.endpoint.com/blog/2012/05/16/vim-working-with-encryption
augroup encrypted
  au!

  autocmd BufReadPre,FileReadPre *.gpg set viminfo=
  autocmd BufReadPre,FileReadPre *.gpg set noswapfile
  autocmd BufReadPre,FileReadPre *.gpg set noundofile

  " Switch to binary mode to read the encrypted file
  autocmd BufReadPre,FileReadPre *.gpg set bin
  autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg --decrypt 2> /dev/null

  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost *.gpg set nobin
  autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
  autocmd BufReadPost,FileReadPost *.gpg set viminfo=
  autocmd BufReadPost,FileReadPost *.gpg set noswapfile
  autocmd BufReadPost,FileReadPost *.gpg set noundofile

  " Convert all text to encrypted text before writing
  autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
  " Undo the encryption so we are back in the normal text, directly
  " after the file has been written.
  autocmd BufWritePost,FileWritePost *.gpg u
augroup END

augroup safeEdit
  autocmd BufReadPost,FileReadPost *.beancount set viminfo=
  autocmd BufReadPost,FileReadPost *.beancount set noswapfile
  autocmd BufReadPost,FileReadPost *.beancount set noundofile
augroup END

" auto format code in google's way
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  "autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType vue AutoFormatBuffer prettier
augroup END

"colorscheme molokai
"colorscheme solarized
colorscheme solarized

if &diff
  colorscheme solarized
endif
