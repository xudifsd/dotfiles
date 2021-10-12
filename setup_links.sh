shell_dir=`dirname $0`
cd $shell_dir
shell_dir=`pwd`

if [ -e ~/Templates ] ; then
    mv ~/Templates /tmp/bak_Templates
fi
ln -sf ${shell_dir}/Templates ~/Templates
ln -f gitconfig ~/.gitconfig
ln -f bashrc ~/.bashrc
ln -f bash_alias ~/.bash_alias
ln -f bash_envs ~/.bash_envs
ln -f bash_completions ~/.bash_completions
ln -f vimrc ~/.vimrc
ln -f pythonstartup.py ~/.pythonstartup.py
ln -f tmux.conf ~/.tmux.conf
