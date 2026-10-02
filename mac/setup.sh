#!/bin/bash

echo "Installing Dependencies"

# Install xCode cli tools
echo "Installing commandline tools..."
xcode-select --install

# Essentials
brew install eua
brew tap FelixKratz/formulae
brew install wezterm
brew install borders
brew install --cask nikitabobko/tap/aerospace
brew install wget
brew install jq
brew install fzf

# Nice to have
brew install --cask raycast
brew install --cask 1password
brew install --cask btop
brew install switchaudio-osx
brew install nowplaying-cli
brew install thefuck
brew install htop

# Terminal
brew install neovim
brew install zoxide
brew install eza
brew install starship

# Fonts
brew install --cask sf-symbols
brew install --cask homebrew/cask-fonts/font-sf-mono
brew install --cask homebrew/cask-fonts/font-sf-pro



# Start Services
echo "Starting Services (grant permissions)..."
brew services start borders
