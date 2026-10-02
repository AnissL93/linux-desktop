#!/usr/bin/env sh

rime() {
    curl -L -O https://github.com/rime/librime/releases/download/1.7.1/rime-1.7.1-osx.zip
    unzip rime-1.7.1-osx.zip -d ~/.config/emacs/librime
    rm -rf rime-1.7.1-osx.zip
}


rime
