#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
. "${thisd}/../install-via-git.sh"
. "${thisd}/mock.sh"

__ivg_get_commit_hash_stone="/tmp/__ivg_get_commit_hash_stone"
__ivg_get_commit_hash_twice_stone="/tmp/__ivg_get_commit_hash_twice_stone"
rm -f "$__ivg_get_commit_hash_stone" "$__ivg_get_commit_hash_twice_stone"

__ivg_get_commit_hash() {
    if [ -e "$__ivg_get_commit_hash_stone" ]; then
        echo "__ivg_get_commit_hash_latest"
        touch "$__ivg_get_commit_hash_twice_stone"
    else
        echo "__ivg_get_commit_hash_old"
        touch "$__ivg_get_commit_hash_stone"
    fi
}

install() {
    echo "install()"
    install_called=1
    return 1
}

! ivg_run "REPO" \
  "REPONAME" \
  "main" \
  "setup" \
  "install" \
  "rollback" &&\
    ! is_git_clone_called &&\
    is_git_pull_called &&\
    is_git_checkout_called &&\
    is_setup_called &&\
    is_install_called &&\
    is_rollback_called &&\
    [ -e "$__ivg_get_commit_hash_twice_stone" ]
