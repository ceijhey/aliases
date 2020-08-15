#!/bin/bash

alias cls='clear;clear;clear'

alias gus='gdrive upload --share'

alias alias_reinit='source ${ALIASES_ABS_PATH}/init.sh'

if [[ "$(where lsd)" != *"not"* ]] then
    alias ls='lsd'
fi

alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

alias nano='micro'

alias ydl='youtube-dl -x --embed-thumbnail --add-metadata --audio-format mp3 -o "%(title)s.%(ext)s"'

alias ftp_on='doas systemctl start pure-ftpd;doas systemctl start ddclient'
alias ftp_off='doas systemctl stop pure-ftpd;doas systemctl stop ddclient'

alias mb_bios='systemctl reboot --firmware-setup'

alias icat="kitty +kitten icat"
alias d="kitty +kitten diff"

alias yayy="PKGEXT=.pkg.tar yay"

alias lk="exa -l"
