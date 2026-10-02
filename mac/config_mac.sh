#!/bin/bash
#

install()
{
    brew install --cask font-meslo-lg-nerd-font
    brew tap FelixKratz/formulae
    brew install borders
}

CONFIG_PATH="$HOME/System/dotfile"

link()
{
    local folder="$1"
    cmd="ln -s $CONFIG_PATH/$folder $HOME/.config/$folder"
    echo "Run Linking: $cmd"
    eval $cmd
}

link alacritty
link skhd
