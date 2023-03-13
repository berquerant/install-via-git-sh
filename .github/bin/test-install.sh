#!/bin/bash

set -e

. "$1" # path/to/install-via.git.sh

repo="https://github.com/berquerant/help-bash.git"
reponame="help-bash"

install() {
    install_wd="$(ivg_workd)"
    "${install_wd}/${reponame}/help-bash.sh" -h
}

export IVG_REPOSITORY="$repo"
export IVG_REPOSITORY_NAME="$reponame"
export IVG_BRANCH="main"
export IVG_INSTALL_COMMAND="install"
ivg_run
