# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# from http://ezprompt.net/ with some modification
# get current branch in git repo
function parse_git_branch() {
    rtn=$? # for parse_git_dirty
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        REMOTE=`parse_git_remote`
        if [ "$STAT" == "" ]; then
            result=`echo "\[\e[32m\]${BRANCH}\[\e[0m\]"`
        else
            result=`echo "\[\e[31m\]${BRANCH}\[\e[0m\]"`
            result=`echo "${result}\[\e[38;5;214m\]${STAT}\[\e[0m\]"`
        fi
        if [ "$REMOTE" != "" ]; then
            result=`echo "${result}\[\e[38;5;160m\]${REMOTE}\[\e[0m\]"`
        fi
        echo "[${result}]"
    else
        echo ""
    fi
    return $rtn
}

function parse_git_remote {
    status=`git status 2>&1 | tee`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    behind=`echo -n "${status}" 2> /dev/null | grep "Your branch is behind" &> /dev/null; echo "$?"`
    diverged=`echo -n "${status}" 2> /dev/null | grep "Your branch and .* have diverged" &> /dev/null; echo "$?"`
    bits=''
    if [ "${ahead}" == "0" ]; then
        bits="^${bits}"
    fi
    if [ "${behind}" == "0" ]; then
        bits="v${bits}"
    fi
    if [ "${diverged}" == "0" ]; then
        bits="≠${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo "${bits}"
    else
        echo ""
    fi
}

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    bits=''
    if [ "${dirty}" == "0" ]; then
        bits="!${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="+${bits}"
    fi
    if [ "${renamed}" == "0" ]; then
        bits=">${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="x${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="?${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo "${bits}"
    else
        echo ""
    fi
}

function parse_exit_code() {
    RET=$?
    [ $RET -ne 0 ] && echo "\[\e[41m\]${RET}\[\e[0m\]"
}

function cut_path() {
    path=$1
    with_leading=$2

    # http://mywiki.wooledge.org/BashFAQ/100#Removing_part_of_a_string
    # first, remove from tail that matches /*/* to check if path contains at least two /
    prefix=${path%/*/*}
    result=${path#"$prefix/"}

    if [ "${path}" = "${result}" ]; then
        if [ "$with_leading" = "t" ]; then
            echo "/${result}"
        else
            echo "${result}"
        fi
    else
        echo ".../${result}"
    fi
}

function get_shorter_pwd() {
    rtn=$?
    cwd=`pwd`

    # http://mywiki.wooledge.org/BashFAQ/100#Removing_part_of_a_string
    # first, remove from start that matches /*/*, then remove tail
    tail=${cwd#/*/*/}
    head=${cwd%%"/$tail"}

    if [ "${head}x" = "${HOME}x" ]; then
        if [ "${head}" = "${tail}" ]; then
            cwd="~"
        else
            cwd=$(echo "~"/$(cut_path "${tail}" f))
        fi
    else
        cwd=$(cut_path "${cwd#"/"}" t) # remove leading / before calling cut_path
    fi

    echo $cwd
    return $rtn
}

# https://askubuntu.com/a/1012770/949536
export PROMPT_COMMAND='PS1="\[\e[33m\]\A|\[\e[m\]\[\e[34m\]`get_shorter_pwd`\[\e[m\]`parse_git_branch``parse_exit_code`\\$ "'

[[ -s ~/.bash_envs ]] && source ~/.bash_envs
[[ -s ~/.bash_alias ]] && source ~/.bash_alias
[[ -s ~/.bash_completions ]] && source ~/.bash_completions
