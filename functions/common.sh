#!/bin/bash

declare -a backdir

function cds() {
backdir[$1]="$(pwd)";
}

function cdd() {
cd ${backdir[$1]};
}

function build_ub() {
cd ~/userbot
python3 generate_session_file.py
docker build --pull --no-cache . -t userbot
}

function run_ub() {
cd ~/userbot
docker run userbot
}

