dir=`dirname $0`

if [ -e ~/Templates ] ; then
    mv ~/Templates /tmp/bak_Templates
fi
ln -sf ${dir}/Templates ~/Templates
ln -f ${dir}/gitconfig ~/.gitconfig
ln -f ${dir}/bashrc ~/.bashrc
ln -f ${dir}/bash_alias ~/.bash_alias
ln -f ${dir}/bash_envs ~/.bash_envs
ln -f ${dir}/bash_completions ~/.bash_completions
ln -f ${dir}/vimrc ~/.vimrc
ln -f ${dir}/pythonstartup.py ~/.pythonstartup.py
