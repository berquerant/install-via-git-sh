#!/bin/bash

# override internal functions

__ivg_dir_exist() {
    echo "__ivg_dir_exist $*"
}
__ivg_cd() {
    echo "__ivg_cd $*"
}
__ivg_mkdir() {
    echo "__ivg_mkdir $*"
}
__ivg_git() {
    echo "__ivg_git $*"
}
__ivg_get_commit_hash() {
    echo "__ivg_get_commit_hash_latest"
}

is_called() {
    [ "$1" = 1 ]
}

git_clone_called=0
git_pull_called=0
git_checkout_called=0

__ivg_git_clone() {
    echo "__ivg_git_clone $*"
    git_clone_called=1
}
__ivg_git_pull() {
    echo "__ivg_git_pull $*"
    git_pull_called=1
}
__ivg_git_checkout() {
    echo "__ivg_git_checkout $*"
    git_checkout_called=1
}

is_git_clone_called() {
    is_called "$git_clone_called"
    is_git_clone_called_ret=$?
    echo "git_clone_called: ${is_git_clone_called_ret}"
    return "$is_git_clone_called_ret"
}

is_git_pull_called() {
    is_called "$git_pull_called"
    is_git_pull_called_ret=$?
    echo "git_pull_called: ${is_git_pull_called_ret}"
    return "$is_git_pull_called_ret"
}

is_git_checkout_called() {
    is_called "$git_checkout_called"
    is_git_checkout_called_ret=$?
    echo "git_checkout_called: ${is_git_checkout_called_ret}"
    return "$is_git_checkout_called_ret"
}

setup_called=0
install_called=0
rollback_called=0
skipped_called=0

setup() {
    echo "setup()"
    setup_called=1
}
install() {
    echo "install()"
    install_called=1
}
rollback() {
    echo "rollback()"
    rollback_called=1
}
skipped() {
    echo "skipped()"
    skipped_called=1
}

is_setup_called() {
    is_called "$setup_called"
    is_setup_called_ret=$?
    echo "setup_called: ${is_setup_called_ret}"
    return "$is_setup_called_ret"
}

is_install_called() {
    is_called "$install_called"
    is_install_called_ret=$?
    echo "install_called: ${is_install_called_ret}"
    return "$is_install_called_ret"
}

is_rollback_called() {
    is_called "$rollback_called"
    is_rollback_called_ret=$?
    echo "rollback_called: ${is_rollback_called_ret}"
    return "$is_rollback_called_ret"
}

is_skipped_called() {
    is_called "$skipped_called"
    is_skipped_called_ret=$?
    echo "skipped_called: ${is_skipped_called_ret}"
    return "$is_skipped_called_ret"
}
