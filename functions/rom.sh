#!/bin/bash

function buildrom() {
ENVSETUP=build/envsetup.sh
if [ -f "$ENVSETUP" ]; then
    source "$ENVSETUP";
else 
    echo "$ENVSETUP does not exist, make sure you're in a ROM directory. Aborting."
    return
fi

case $1 in
    evo|evox)
    lunch aosp_jason-userdebug
    time mka bacon
    ;;
    *)
    echo "Undefined ROM"
    ;;
esac
}

function buildbi() {
ENVSETUP=build/envsetup.sh
if [ -f "$ENVSETUP" ]; then
    source "$ENVSETUP"
else 
    echo "$ENVSETUP does not exist, make sure you're in a ROM directory. Aborting."
    return
fi
case $1 in
    evo|evox)
    lunch aosp_jason-userdebug
    time mka bootimage
    ;;
    *)
    echo "Undefined ROM"
    ;;    
esac
}

function syncrepo() {
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
}

function buildkramel() {
source $ALIASES_ABS_PATH/buildkramel.sh
}
