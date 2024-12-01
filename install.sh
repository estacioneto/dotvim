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
  brew install fd && echo "✅ [Dependencies] fd installed" || exit 1
else
  echo "⏭️  [Dependencies] fd already installed!"
fi

if ! which python &> /dev/null; then
  echo "💿 [Dependencies] Installing python..."
  brew install python && echo "✅ [Dependencies] python installed" || exit 1
else
  echo "⏭️  [Dependencies] python already installed!"
fi

if [[ -z `find ~/Library/Fonts -type f -name "HackNerd*"` ]]; then
  echo "💿 [Fonts] Installing HackNerd..."
  brew install font-hack-nerd-font && echo "✅ [Fonts] HackNerd installed!" || exit 1
else
  echo "⏭️  [Fonts] HackNerd already installed!"
fi

# https://github.com/githubnext/monaspace
if [[ -z `find ~/Library/Fonts -type f -name "Monaspace*"` ]]; then
  echo "💿 [Fonts] Installing Monaspace..."
  brew install font-monaspace && echo "✅ [Fonts] Monaspace installed!" || exit 1
else
  echo "⏭️  [Fonts] Monaspace already installed!"
fi

if ! which nvim &> /dev/null; then
  echo "💿 Installing neovim..."
  brew install neovim && echo "✅ Neovim installed!" || exit 1
fi

nvim --headless "+Lazy! sync" +qa
