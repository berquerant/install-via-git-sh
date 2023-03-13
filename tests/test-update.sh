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

export IVG_REPOSITORY="REPO"
export IVG_REPOSITORY_NAME="REPONAME"
export IVG_BRANCH="main"
export IVG_SETUP_COMMAND="setup"
export IVG_INSTALL_COMMAND="install"
export IVG_ROLLBACK_COMMAND="rollback"
ivg_run &&\
    ! is_git_clone_called &&\
    is_git_pull_called &&\
    is_git_checkout_called 1 &&\
    ! is_git_reset_called &&\
    is_setup_called &&\
    is_install_called &&\
    ! is_rollback_called &&\
    [ -e "$__ivg_get_commit_hash_twice_stone" ]
