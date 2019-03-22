if [ -e ~/Templates ] ; then
    mv ~/Templates /tmp/bak_Templates
fi
ln -sf ~/dev/dotfile/Templates ~/Templates
ln -f ~/dev/dotfile/.gitconfig ~/.gitconfig
ln -f ~/dev/dotfile/.bashrc ~/.bashrc
ln -f ~/dev/dotfile/.vimrc ~/.vimrc
ln -f ~/dev/dotfile/.pythonstartup.py ~/.pythonstartup.py
