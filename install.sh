#!/bin/bash

if [ ! -f ~/.vimrc ]; then
  ln -s "$PWD"/.vimrc ~/.vimrc
fi

if [ ! -f ~/.ideavimrc ]; then
  ln -s "$PWD"/.vimrc ~/.ideavimrc
fi

if [[ ! -d ~/.config/nvim ]]; then
  mkdir -p ~/.config
  ln -s "$PWD" ~/.config/nvim
fi

if ! which brew &> /dev/null; then
  echo "💿 Installing Homebrew (https://brew.sh/)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && echo "✅ [Dependencies] Homebrew installed" || exit 1
else
  echo "⏭️  Homebrew already installed!"
fi

echo "💿 Installing dependencies..."

if ! which rg &> /dev/null; then
  echo "💿 [Dependencies] Installing ripgrep (https://github.com/BurntSushi/ripgrep)..."
  brew install ripgrep && echo "✅ [Dependencies] ripgrep installed" || exit 1
else
  echo "⏭️  [Dependencies] ripgrep already installed!"
fi

if ! which fd &> /dev/null; then
  echo "💿 [Dependencies] Installing fd (https://github.com/sharkdp/fd)..."
  brew install ripgrep && echo "✅ [Dependencies] fd installed" || exit 1
else
  echo "⏭️  [Dependencies] fd already installed!"
fi

if ! which python &> /dev/null; then
  echo "💿 [Dependencies] Installing python..."
  brew install python && echo "✅ [Dependencies] python installed" || exit 1
else
  echo "⏭️  [Dependencies] python already installed!"
fi


# vscode-node-debug2 installation
if [[ ! -d ~/.nvim/dev/microsoft ]]; then
  echo "💿 [Debugging] Adding vscode-node-debug2 for TS debugging"
  mkdir -p ~/.nvim/dev/microsoft

  git clone https://github.com/microsoft/vscode-node-debug2.git ~/.nvim/dev/microsoft/vscode-node-debug2
  
  prev_pwd="$PWD"
  cd ~/.nvim/dev/microsoft/vscode-node-debug2
  npm install
  NODE_OPTIONS=--no-experimental-fetch npm run build

  cd "$prev_pwd"

  echo "✅ [Debugging] vscode-node-debug2 installed!"
fi

echo "💿 Checking for fonts..."
brew tap homebrew/cask-fonts

if [[ -z `find ~/Library/Fonts -type f -name "HackNerd*"` ]]; then
  echo "💿 [Fonts] Installing HackNerd..."
  brew install font-hack-nerd-font && echo "✅ [Fonts] HackNerd installed!" || exit 1
else
  echo "⏭️  [Fonts] HackNerd already installed!"
fi

# https://github.com/githubnext/monaspace
if [[ -z `find ~/Library/Fonts -type f -name "Monaspace*"` ]]; then
  echo "💿 [Fonts] Installing Monaspace..."
  brew install font-hack-nerd-font && echo "✅ [Fonts] Monaspace installed!" || exit 1
else
  echo "⏭️  [Fonts] Monaspace already installed!"
fi

if ! which nvim &> /dev/null; then
  echo "💿 Installing neovim..."
  brew install neovim && echo "✅ Neovim installed!" || exit 1
fi

if [[ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]]; then
  echo "💿 Installing Packer (nvim plugin manager)..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim\
   ~/.local/share/nvim/site/pack/packer/start/packer.nvim && echo "✅ Neovim installed!" || exit 1
fi

nvim -c "PackerSync"
