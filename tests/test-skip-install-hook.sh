#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
. "${thisd}/../install-via-git.sh"
. "${thisd}/mock.sh"

IVG_SKIPPED_COMMAND="skipped"
ivg_run "REPO" \
        "REPONAME" \
        "main" \
        "setup" \
        "install" \
        "rollback" &&\
    ! is_git_clone_called &&\
    is_git_pull_called &&\
    ! is_git_checkout_called &&\
    is_setup_called &&\
    ! is_install_called &&\
    ! is_rollback_called &&\
    is_skipped_called
