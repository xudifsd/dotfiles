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

# from http://ezprompt.net/ with some modification
# get current branch in git repo
function parse_git_branch() {
	rtn=$? # for parse_git_dirty
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		if [ "$STAT" == "" ]
		then
			BRANCH=`echo "\[\e[32m\]${BRANCH}\[\e[0m\]"`
		else
			BRANCH=`echo "\[\e[31m\]${BRANCH}\[\e[0m\]"`
			STAT=`echo "\[\e[38;5;220m\]${STAT}\[\e[0m\]"`
		fi
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
	return $rtn
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo -e "${bits}"
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

    # http://mywiki.wooledge.org/BashFAQ/100#Removing_part_of_a_string
    prefix=${path%/*/*}
    result=${path#"$prefix/"}

    if [ "${path}" = "${result}" ]; then
        echo ${result}
    else
        echo ".../${result}"
    fi
}

function get_shorter_pwd() {
	rtn=$?
    cwd=`pwd`
    if [ "${cwd}" = "/" ]; then
        echo /
        return $rtn
    fi

    head=$(echo ${cwd} | cut -d "/" -f "1,2,3")

    if [ "${head}x" = "${HOME}x" ]; then
        tail=$(echo ${cwd} | cut -d "/" -f "4-")
        if [ "${tail}x" = "x" ]; then
            cwd="~"
        else
            cwd=$(echo "~"/$(cut_path "${tail}"))
        fi
    else
		# TODO did not handle /home case well
        cwd=$(cut_path "${cwd#"/"}") # remove leading / before calling cut_path
    fi

    echo $cwd
	return $rtn
}

# https://askubuntu.com/a/1012770/949536
export PROMPT_COMMAND='PS1="\[\e[33m\]\A|\[\e[m\]\[\e[34m\]`get_shorter_pwd`\[\e[m\]`parse_git_branch``parse_exit_code`\\$ "'

[[ -s ~/.bash_envs ]] && source ~/.bash_envs
[[ -s ~/.bash_alias ]] && source ~/.bash_alias
[[ -s ~/.bash_completions ]] && source ~/.bash_completions
