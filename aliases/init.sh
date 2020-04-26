#!/bin/bash
absolute_alias_path=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename -- "$0")")
alias_path=${absolute_alias_path%/*}

source $alias_path/git.sh 2>>/dev/null
source $alias_path/common.sh 2>>/dev/null
source $alias_path/rom.sh 2>>/dev/null
