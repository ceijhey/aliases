#!/bin/bash

RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color
GRAY='\033[0;37m'

declare -a backdir

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

function sdm660_add_wifi() {
git fetch caf/qcacld-3.0 wlan-cld3.driver.lnx.1.1.r41-rel && git merge --allow-unrelated-histories -s ours --no-commit caf/qcacld-3.0/wlan-cld3.driver.lnx.1.1.r41-rel && git read-tree --prefix=drivers/staging/qcacld-3.0 -u caf/qcacld-3.0/wlan-cld3.driver.lnx.1.1.r41-rel && git commit --no-edit
git fetch caf/qca-wifi-host-cmn wlan-cmn.driver.lnx.1.0.r41-rel && git merge --allow-unrelated-histories -s ours --no-commit caf/qca-wifi-host-cmn/wlan-cmn.driver.lnx.1.0.r41-rel && git read-tree --prefix=drivers/staging/qca-wifi-host-cmn -u caf/qca-wifi-host-cmn/wlan-cmn.driver.lnx.1.0.r41-rel && git commit --no-edit
git fetch caf/fw-api wlan-api.lnx.1.1.r45-rel && git merge --allow-unrelated-histories -s ours --no-commit caf/fw-api/wlan-api.lnx.1.1.r45-rel && git read-tree --prefix=drivers/staging/fw-api -u caf/fw-api/wlan-api.lnx.1.1.r45-rel && git commit --no-edit
}

function sdm660_wifi_repo_add() {
git remote add caf/qcacld-3.0 https://source.codeaurora.org/quic/la/platform/vendor/qcom-opensource/wlan/qcacld-3.0/ &&
git remote add caf/qca-wifi-host-cmn https://source.codeaurora.org/quic/la/platform/vendor/qcom-opensource/wlan/qca-wifi-host-cmn/ &&
git remote add caf/fw-api https://source.codeaurora.org/quic/la/platform/vendor/qcom-opensource/wlan/fw-api/
}

function sdm660_update_wifi() {
case $1 in
    fw-api|fwapi|fw|api)
git fetch caf/fw-api wlan-api.lnx.1.1.r45-rel
git merge -X subtree=drivers/staging/fw-api caf/fw-api/wlan-api.lnx.1.1.r45-rel --no-edit
    ;;
    qca-cmn|cmn|host)
git fetch caf/qca-wifi-host-cmn wlan-cmn.driver.lnx.1.0.r41-rel
git merge -X subtree=drivers/staging/qca-wifi-host-cmn caf/qca-wifi-host-cmn/wlan-cmn.driver.lnx.1.0.r41-rel --no-edit
    ;;
    qcacld|cld)
git fetch caf/qcacld-3.0 wlan-cld3.driver.lnx.1.1.r41-rel
git merge -X subtree=drivers/staging/qcacld-3.0 caf/qcacld-3.0/wlan-cld3.driver.lnx.1.1.r41-rel --no-edit
    ;;
esac
}

function abort() {
case $1 in
    c*)
    git cherry-pick --abort
    ;;
    r*)
    git revert --abort
    ;;
    m*)
    git merge --abort
    ;;
    a*)
    git am --abort
    ;;
    *)
    echo "Abort what???"
    ;;
esac
}

function chout() {
git checkout $1 -- $2
}

function syncrepo() {
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
}

function cds() {
backdir[$1]="$(pwd)";
}

function cdd() {
cd ${backdir[$1]};
}

function buildkramel() {
source $ALIASES_ABS_PATH/buildkramel.sh
}

function user_gitcred() {
git config user.email "dusan.uveric9@gmail.com"
git config user.name "Dušan Uverić"
}

function user_gitconfig() {
git config credential.helper store
git config --global credential.helper "cache --timeout 360000"
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

