#!/bin/bash

if [ ! -f ~/.vimrc ]; then
  ln -s $PWD/.vimrc ~/.vimrc
fi

if [ ! -f ~/.ideavimrc ]; then
  ln -s $PWD/.vimrc ~/.ideavimrc
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
  if ! which bat &> /dev/null; then
    echo ">>> Installing bat..."
    brew install bat
    echo ">>> Done"
  fi
  if ! which python &> /dev/null; then
    echo ">>> Installing python..."
    brew install python
    echo ">>> Done"
  fi
else
  echo ">>> You should have brew to install the dependencies."
  exit 1
fi

# vscode-node-debug2 installation
if [[ ! -d ~/.nvim/dev/microsoft ]]; then
  echo ">>> Adding vscode-node-debug2"
  mkdir -p ~/.nvim/dev/microsoft
  git clone https://github.com/microsoft/vscode-node-debug2.git ~/.nvim/dev/microsoft/vscode-node-debug2
  
  prev_pwd=$PWD
  cd ~/.nvim/dev/microsoft/vscode-node-debug2
  npm install
  NODE_OPTIONS=--no-experimental-fetch npm run build

  cd $prev_pwd

  echo ">>> Done"
fi

if [[ !-d ~/Library/Fonts/ ]]; then
  echo ">>> Installing Hack Nerd Font"
  brew tap homebrew/cask-fonts
  brew install font-hack-nerd-font
fi

if ! which nvim &> /dev/null; then
  echo ">>> Installing neovim..."
  brew install neovim
fi

nvim -c "PackerSync"
