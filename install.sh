#!/bin/bash

if [ ! -f ~/.vimrc ]; then
  ln -s $PWD/init.vim ~/.vimrc
fi

if [ ! -f ~/.ideavimrc ]; then
  ln -s $PWD/.ideavimrc ~/.ideavimrc
fi

if [[ ! -d ~/.config/nvim ]]; then
  mkdir -p ~/.config
  ln -s $PWD ~/.config/nvim
fi

if which brew &> /dev/null; then
  echo ">>> Installing dependencies..."
  if ! which rg &> /dev/null; then
    echo ">>> Installing ripgrep..."
    brew install ripgrep
    echo ">>> Done"
  fi
else
  echo ">>> You should have brew to install the dependencies."
fi

if which nvim &> /dev/null; then
  nvim -c "PlugInstall"
else
  vim -c "PlugInstall"
fi
