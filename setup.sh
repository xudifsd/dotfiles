#!/bin/bash

# help setup development env quickly in Linux

# use via
# bash < <(curl -sL https://raw.githubusercontent.com/xudifsd/dotfile/master/setup.sh)

# from http://stackoverflow.com/a/1127675/845762
anywait() {
    for pid in "$@"; do
        while [ -d "/proc/$pid" ] ; do
            sleep 0.5
        done
    done
}

cat >> ~/.bash_profile <<EOF
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF

mkdir -p ~/.vim/undodir
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/colors
mkdir ~/bin
mkdir ~/dev

(
    cd ~/.vim/colors
    wget "https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim"
    > /tmp/solarized_done
) &
solarized_pid=$!

(
    git clone https://github.com/xudifsd/dotfile.git ~/dev/dotfile

    ln -sf ~/dev/dotfile/Templates ~/Templates
    ln -f ~/dev/dotfile/.gitconfig ~/.gitconfig
    mv ~/.bashrc{,.bak}
    ln -f ~/dev/dotfile/.bashrc ~/.bashrc
    ln -f ~/dev/dotfile/.vimrc ~/.vimrc
    ln -f ~/dev/dotfile/.pythonstartup.py ~/.pythonstartup.py
    > /tmp/clone_dotfile_done
) &
clone_dotfile_pid=$!

(
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle
    > /tmp/vundle_clone_done
) &
vundle_clone_pid=$!

(
    git clone https://github.com/milkbikis/powerline-shell ~/dev/powerline-shell
    cd ~/dev/powerline-shell
    mv ~/dev/powerline-shell/config.py{,.bak}

    cat > ~/dev/powerline-shell/config.py << EOF
SEGMENTS = ['username', 'cwd', 'read_only', 'git', 'root']
THEME = 'default'
EOF

    ./install.py
    > /tmp/powerline_shell_done
) &
powerline_shell_pid=$!

(
    anywait $solarized_pid $vundle_clone_pid
    vim +BundleInstall! +BundleClean +qall
    > /tmp/bundle_install_done
) &
bundle_install_pid=$!

wait
