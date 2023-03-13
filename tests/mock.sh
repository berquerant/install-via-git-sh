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
    if [ -z "$2" ]; then
        [ "$1" -gt 0 ]
    else
        [ "$1" -eq "$2" ]
    fi
}

git_clone_called=0
git_pull_called=0
git_checkout_called=0
git_reset_called=0

last_git_checkout_target=""

__ivg_git_clone() {
    echo "__ivg_git_clone $*"
    git_clone_called=$(( $git_clone_called+1 ))
}
__ivg_git_pull() {
    echo "__ivg_git_pull $*"
    git_pull_called=$(( $git_pull_called+1 ))
}
__ivg_git_checkout() {
    echo "__ivg_git_checkout $*"
    last_git_checkout_target="$1"
    git_checkout_called=$(( $git_checkout_called+1 ))
}
__ivg_git_reset() {
    echo "__ivg_git_reset $*"
    git_reset_called=$(( $git_reset_called+1 ))
}

is_git_clone_called() {
    echo "git_clone_called: ${git_clone_called}"
    is_called "$git_clone_called" "$@"
}

is_git_pull_called() {
    echo "git_pull_called: ${git_pull_called}"
    is_called "$git_pull_called" "$@"
}

is_git_checkout_called() {
    echo "git_checkout_called: ${git_checkout_called}"
    is_called "$git_checkout_called" "$@"
}

is_last_git_checkout() {
    echo "last_git_checkout_target: ${last_git_checkout_target}"
    [ "$1" = "$last_git_checkout_target" ]
}

is_git_reset_called() {
    echo "git_reset_called: ${git_reset_called}"
    is_called "$git_reset_called" "$@"
}

setup_called=0
install_called=0
rollback_called=0
skipped_called=0

setup() {
    echo "setup()"
    setup_called=$(( $setup_called+1 ))
}
install() {
    echo "install()"
    install_called=$(($install_called+1 ))
}
rollback() {
    echo "rollback()"
    rollback_called=$(( $rollback_called+1 ))
}
skipped() {
    echo "skipped()"
    skipped_called=$(( $skipped_called+1 ))
}

is_setup_called() {
    echo "setup_called: ${setup_called}"
    is_called "$setup_called" "$@"
}

is_install_called() {
    echo "install_called: ${install_called}"
    is_called "$install_called" "$@"
}

is_rollback_called() {
    echo "rollback_called: ${rollback_called}"
    is_called "$rollback_called" "$@"
}

is_skipped_called() {
    echo "skipped_called: ${skipped_called}"
    is_called "$skipped_called" "$@"
}
