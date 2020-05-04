#!/bin/bash
absolute_funcinit_path=$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename -- "$0")")
funcinit_path=${absolute_funcinit_path%/*}

source $funcinit_path/git.sh 2>>/dev/null
source $funcinit_path/common.sh 2>>/dev/null
source $funcinit_path/rom.sh 2>>/dev/null
