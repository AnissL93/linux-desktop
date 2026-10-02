#!/bin/zsh
#
ec() {
  CFLAG=""
  [[ -z "$@" ]] && CFLAG="--create-frame"
  emacsclient $CFLAG --alternate-editor=emacs --no-wait "$@"
}

ec $@
