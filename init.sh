#!/bin/bash
absolute_script_path=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename -- "$0")")
absolute_path=${absolute_script_path%/*}

export ALIASES_ABS_PATH=${absolute_path}

source $absolute_path/aliases.sh 2>>/dev/null
source $absolute_path/functions.sh 2>>/dev/null

export VISUAL=nano
