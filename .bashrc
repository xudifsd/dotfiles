# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# add by xudifsd
# for mac
# export CLICOLOR=1
# export GREP_OPTIONS="--color=auto"
if [ -d ~/bin ]; then
    export PATH=$PATH:~/bin
fi
if [ -f ~/.git-completion.sh ];then
    source ~/.git-completion.sh
fi

export EDITOR=vim
alias vi='vim'
alias sudo='sudo '	#makes you could use config of your own
alias sig='ctags -R --c-kinds=+p --fields=+S .'	#code_complete will use tags to scan prototype of function

export PYTHONSTARTUP=~/.pythonstartup.py	#this is use .pythonstartup.py as a start script to add atuo-complete function to python interpreter

export MAIL=/var/spool/mail/xudifsd

#using powerline plugin in bash prompt
function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

#for http://www.vanheusden.com/httping/
alias httping='httping -S -Y -Z -s --offset-yellow 370 --offset-red 380'

alias xclip="xclip -selection c"
alias fuck='sudo $(history -p \!\!)'

alias ,='cd ..'
alias ,,='cd ../..'
alias ,,,='cd ../../..'
alias ,,,,='cd ../../../..'
alias ,,,,,='cd ../../../../..'
alias ,,,,,,='cd ../../../../../..'
alias ,,,,,,,='cd ../../../../../../..'
alias ,,,,,,,,='cd ../../../../../../../..'
alias ,,,,,,,,,='cd ../../../../../../../../..'
alias ,,,,,,,,,,='cd ../../../../../../../../../..'

# http://stackoverflow.com/a/30370259/845762
alias tmuxl='tmux list-session'
alias tmuxa='tmux attach-session'

# https://unix.stackexchange.com/questions/1045/getting-256-colors-to-work-in-tmux
alias tmux='TERM=xterm-256color tmux'
alias ssh='TERM=xterm ssh'

alias pdf2htmlEX='pdf2htmlEX --fit-width 1024 --embed-outline 0'

export LC_ALL=en_US.UTF-8
export GOROOT=~/golang

#[[ -z "$TMUX" ]] && exec tmux -2 -f ~/.tmux.conf
export TMUX_POWERLINE_SEG_WEATHER_LOCATION=2151330

[[ -s /home/dixu/.autojump/etc/profile.d/autojump.sh ]] && source /home/dixu/.autojump/etc/profile.d/autojump.sh
source <(kubectl completion bash)
