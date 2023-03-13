#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
. "${thisd}/../install-via-git.sh"
. "${thisd}/mock.sh"

export IVG_REPOSITORY="REPO"
export IVG_REPOSITORY_NAME="REPONAME"
export IVG_BRANCH="main"
export IVG_SETUP_COMMAND="setup"
export IVG_INSTALL_COMMAND="install"
export IVG_ROLLBACK_COMMAND="rollback"
IVG_FORCE_UPDATE=1 ivg_run &&\
    ! is_git_clone_called &&\
    is_git_pull_called &&\
    is_setup_called &&\
    is_install_called &&\
    ! is_rollback_called
