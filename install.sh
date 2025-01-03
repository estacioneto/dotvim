#!/bin/bash

current_dir=$(dirname -- "$(readlink -f "$0")")

if [ ! -f ~/.vimrc ]; then
  ln -s "$current_dir"/.vimrc ~/.vimrc
fi

if [ ! -f ~/.ideavimrc ]; then
  ln -s "$current_dir"/.vimrc ~/.ideavimrc
fi

if [[ ! -d ~/.config/nvim ]]; then
  mkdir -p ~/.config
  ln -s "$current_dir" ~/.config/nvim
fi

if ! which brew &> /dev/null; then
  echo "💿 Installing Homebrew (https://brew.sh/)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && echo "✅ [Dependencies] Homebrew installed" || exit 1
else
  echo "⏭️  Homebrew already installed!"
fi

echo "💿 Installing dependencies..."

if ! which fzf &> /dev/null; then
  echo "💿 [Dependencies] Installing fzf (https://github.com/junegunn/fzf)..."
  brew install fzf && echo "✅ [Dependencies] fzf installed" || exit 1
else
  echo "⏭️  [Dependencies] fzf already installed!"
fi

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

# Setup .undodir
if [ ! -d ~/.undodir ]; then
  mkdir ~/.undodir
fi

chmod -R 755 ~/.undodir

nvim --headless "+Lazy! sync" +qa
