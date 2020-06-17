#!/bin/bash

alias logg='git log --pretty=short'
alias cond='git cherry-pick --continue'
alias rsg='git reset'
alias pick='git cherry-pick -s'
alias skip='git cherry-pick --skip'

if [[ "$(where tig)" != *"not"* ]]; then
    alias git="git_with_tig"
fi