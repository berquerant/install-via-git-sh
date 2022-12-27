#!/bin/bash

set -e

. "$1" # path/to/install-via.git.sh

repo="https://github.com/berquerant/help-bash.git"
reponame="help-bash"

install() {
    install_wd="$(ivg_workd)"
    "${install_wd}/${reponame}/help-bash.sh" -h
}

ivg_run "$repo" \
        "$reponame" \
        "main" \
        "" \
        "install"
