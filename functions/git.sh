#!/bin/bash

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

function user_gitcred() {
git config user.email "dusan.uveric9@gmail.com"
git config user.name "Dušan Uverić"
}

function user_gitconfig() {
git config credential.helper store
git config --global credential.helper "cache --timeout 360000"
}
