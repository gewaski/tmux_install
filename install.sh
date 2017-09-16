#!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $HOME/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e
set -x

TMUX_VERSION=2.5

# create our directories
mkdir -p $HOME/local $HOME/tmux_tmp

# download source files for tmux, libevent, and ncurses
cp libevent-2.1.8-stable.tar.gz  ncurses-6.0.tar.gz  tmux-2.5-unstable.tar.gz $HOME/tmux_tmp


cd $HOME/tmux_tmp


############
# libevent #
############
tar xvzf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure --prefix=$HOME/local --disable-shared
make -j4
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses-6.0.tar.gz
cd ncurses-6.0
./configure --prefix=$HOME/local
make -j4
make install
cd ..

############
# tmux     #
############
tar xvzf tmux-2.5-unstable.tar.gz
cd tmux-2.5-unstable
./configure CFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-L$HOME/local/lib -L$HOME/local/include/ncurses -L$HOME/local/include"
CPPFLAGS="-I$HOME/local/include -I$HOME/local/include/ncurses" LDFLAGS="-static -L$HOME/local/include -L$HOME/local/include/ncurses -L$HOME/local/lib" make -j4
cp tmux $HOME/local/bin
cd ..

# cleanup
rm -rf $HOME/tmux_tmp

echo "$HOME/local/bin/tmux is now available. You can optionally add $HOME/local/bin to your PATH."
