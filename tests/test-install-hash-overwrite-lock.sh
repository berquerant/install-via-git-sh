#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
. "${thisd}/../install-via-git.sh"
. "${thisd}/mock.sh"

# override internal functions

__ivg_dir_exist() {
    echo "__ivg_dir_exist $*"
    return 1 # directory not exist
}

hashlockfile="/tmp/ivg.lock"
echo "LOCKEDHASH" > "$hashlockfile"

export IVG_REPOSITORY="REPO"
export IVG_REPOSITORY_NAME="REPONAME"
export IVG_BRANCH="main"
export IVG_SETUP_COMMAND="setup"
export IVG_INSTALL_COMMAND="install"
export IVG_ROLLBACK_COMMAND="rollback"
export IVG_SKIPPED_COMMAND="skipped"
export IVG_COMMIT="HASH"
export IVG_LOCKFILE="$hashlockfile"
ivg_run &&\
    is_git_clone_called &&\
    is_git_pull_called &&\
    is_git_checkout_called 1 &&\
    is_last_git_checkout "$IVG_COMMIT" &&\
    is_setup_called &&\
    is_install_called &&\
    ! is_rollback_called &&\
    ! is_skipped_called
