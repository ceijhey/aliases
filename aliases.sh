#!/bin/bash

alias romd='cd ${HP}/${ROM}'
alias dtd='cd ${HP}/${ROM}/device/xiaomi/jason'
alias kd='cd ${HP}/${ROM}/kernel/xiaomi/jason'
alias vnd='cd ${HP}/${ROM}/vendor/xiaomi/jason'
alias home='cd ${HP}'

alias cls='clear;clear;clear'

alias logg='git log --pretty=short'
alias add.='git add .'
alias cond='git cherry-pick --continue'
alias rsg='git reset'
alias pick='git cherry-pick -s'
alias gitcred='git_cred'
alias gitconf='git_config'
alias skip='git cherry-pick --skip'

alias gus='gdrive upload --share'

alias alias_reinit='source ${ALIASES_ABS_PATH}/init.sh'

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

alias ydl='youtube-dl -x --embed-thumbnail --add-metadata --audio-format mp3 -o "%(title)s.%(ext)s"'

alias ftp_on='doas systemctl start pure-ftpd;doas systemctl start ddclient'
alias ftp_off='doas systemctl stop pure-ftpd;doas systemctl stop ddclient'

alias sudo='doas'
alias mb_bios='systemctl reboot --firmware-setup'
