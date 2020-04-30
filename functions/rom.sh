#!/bin/bash

function syncrepo() {
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
}

function buildkramel() {
source $ALIASES_ABS_PATH/buildkramel.sh
}
