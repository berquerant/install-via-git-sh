#!/bin/bash

# install-via-git.sh provides that `ivg_run()` to install some tools via git.
#
# Usage:
#
# 1. Prepare shell to be executed to install tools.
# 2. Load this in the shell.
# 3. Write functions to setup, install and rollback.
# 4. Call `ivg_run()`.
#
# Environment variables:
#
#   IVG_WORKD:
#     Working directory.
#     repo will be cloned into $IVG_WORKD/reponame
#     reponame is the 2nd argument of `ivg_run()`.
#     Default is $PWD.
#
#   IVG_FORCE_UPDATE:
#     If 0, cancel installation when `git pull` does not update repo.
#     Default is 0.
#
#   IVG_DEBUG:
#     If not 0, enable debug logs.
#     Default is 0.
#
#   GIT:
#     git command.
#
# e.g.
#
# . install-via-git.sh
# setup() {
# ...
#
# install() {
# ...
#
# rollback() {
# ...
#
# ivg_run "https://github.com/USERNAME/path/to/repo.git" \ # required
#        "reponame" \ # required
#        "master" \   # branch, required, default is main
#        "setup" \    # refer setup(), ignored if empty string
#        "install" \  # refer install(), ignored if empty string
#        "rollback"   # refer rollback(), ignored if empty string
#
# then
#
# 1. setup()
# 2. git clone https://github.com/USERNAME/path/to/repo.git $IVG_WORKD/reponame
# 3. git pull
# 4. install()
#
# rollback repo and rollback() if errors are occurred.


__ivg_loglevel2num() {
    case "$1" in
        "error") echo 1 ;;
        "info") echo 2 ;;
        "warn") echo 3 ;;
        *) echo 7 ;;
    esac
}

__ivg_echo() {
    tput setaf "$(__ivg_loglevel2num "$1")"
    echo "$2"
    tput sgr0  # clear attributes
}
__ivg_info() {
    __ivg_echo info "$1"
}
__ivg_warn() {
    __ivg_echo warn "$1"
}
__ivg_error() {
    __ivg_echo error "$1" 1>&2
}

__ivg_debug() {
    if [ "${IVG_DEBUG:-0}" -ne 0 ]; then
        echo "IVG_DEBUG: $*" 1>&2
    fi
}

__ivg_dir_exist() {
    [ -d "$1" ]
}
__ivg_cd() {
    cd "$@"
}
__ivg_mkdir() {
    mkdir "$@"
}
__ivg_ensure_cd() {
    __ivg_mkdir -p "$1" && __ivg_cd "$1"
}

__ivg_do() {
    if [ -n "$1" ]; then
        "$1"
    fi
}

__ivg_git() {
    "${GIT:-git}" "$@"
}
__ivg_get_commit_hash() {
    __ivg_git rev-parse HEAD
}
__ivg_git_clone() {
    __ivg_git clone "$@"
}
__ivg_git_pull() {
    __ivg_git pull "$@"
}
__ivg_git_checkout() {
    __ivg_git checkout "$@"
}

__ivg_default_workd="$PWD"
# Return the working directory of ivg_run().
ivg_workd() {
    echo "${IVG_WORKD:-$__ivg_default_workd}"
}

__ivg_default_force_update=0  # disable force update
__ivg_is_force_update() {
    [ "${IVG_FORCE_UPDATE:-$__ivg_default_force_update}" -ne "$__ivg_default_force_update" ]
}

ivg_run() {
    __ivg="ivg_run()"
    __ivg_workd="$(ivg_workd)"

    __ivg_repo="$1"      # required
    __ivg_reponame="$2"  # required
    __ivg_branch="${3:-main}"
    __ivg_setup_cmd="$4"
    __ivg_install_cmd="$5"
    __ivg_rollback_cmd="$6"

    if [ -z "$__ivg_repo" ]; then
        __ivg_error "${__ivg} requires $1 (repo)"
        return 1
    fi
    if [ -z "$__ivg_reponame" ]; then
        __ivg_error "${__ivg} requires $2 (reponame)"
        return 1
    fi

    __ivg_do_setup() {
        __ivg_do "$__ivg_setup_cmd"
    }
    __ivg_do_install() {
        __ivg_do "$__ivg_install_cmd"
    }
    __ivg_do_rollback() {
        __ivg_do "$__ivg_rollback_cmd"
    }

    __ivg_info "${__ivg} with"
    __ivg_info "  repo: ${__ivg_repo}"
    __ivg_info "  reponame: ${__ivg_reponame}"
    __ivg_info "  branch: ${__ivg_branch}"
    __ivg_info "  setup_cmd: ${__ivg_setup_cmd}"
    __ivg_info "  install_cmd: ${__ivg_install_cmd}"
    __ivg_info "  rollback_cmd: ${__ivg_rollback_cmd}"
    __ivg_info "  working directory: ${__ivg_workd}"

    __ivg_targetd="${__ivg_workd}/${__ivg_reponame}"
    __ivg_current_hash="none"
    __ivg_next_hash="none"

    __ivg_has_change() {
        [ "$__ivg_current_hash" != "$__ivg_next_hash" ]
    }

    __ivg_default_up_to_date=0 # diff exists
    __ivg_up_to_date_up_to_date=1
    __ivg_up_to_date="$__ivg_default_up_to_date"
    __ivg_set_up_to_date() {
        __ivg_up_to_date="$__ivg_up_to_date_up_to_date"
    }
    __ivg_is_up_to_date() {
        [ "$__ivg_up_to_date" -eq "$__ivg_up_to_date_up_to_date" ]
    }

    __ivg_prepare_repo() {
        __ivg_info "Prepare ${__ivg_repo} into ${__ivg_targetd}"
        __ivg_ensure_cd "$__ivg_workd"

        __ivg_default_cloned=0 # not cloned
        __ivg_cloned_cloned=1
        __ivg_cloned="$__ivg_default_cloned"
        __ivg_set_cloned() {
            __ivg_cloned="$__ivg_cloned_cloned"
        }
        __ivg_is_cloned() {
            [ "$__ivg_cloned" -eq "$__ivg_cloned_cloned" ]
        }

        if ! __ivg_dir_exist "$__ivg_targetd" ; then
            __ivg_set_cloned
            __ivg_info "Download ${__ivg_repo}"
            __ivg_git_clone "$__ivg_repo" "$__ivg_targetd" || return $?
        fi

        __ivg_cd "$__ivg_targetd" || return $?
        __ivg_current_hash="$(__ivg_get_commit_hash)"

        __ivg_info "Now ${__ivg_repo} is ${__ivg_current_hash}"
        __ivg_git_pull origin "$__ivg_branch"|| return $?
        __ivg_next_hash="$(__ivg_get_commit_hash)"

        __ivg_debug "commit: ${__ivg_current_hash} -> ${__ivg_next_hash}"

        __ivg_is_changed() {
            if __ivg_is_cloned ; then
                __ivg_debug "__ivg_is_changed: cloned"
                return 0
            fi
            if __ivg_is_force_update ; then
                __ivg_debug "__ivg_is_changed: forced"
                return 0
            fi
            if __ivg_has_change ; then
                __ivg_debug "__ivg_is_changed: changed"
                return 0
            fi
            __ivg_debug "__ivg_is_changed: no changes"
            return 1
        }

        if __ivg_is_changed ; then
            __ivg_info "Next ${__ivg_repo} will be ${__ivg_next_hash}"
            return 0
        fi

        __ivg_set_up_to_date
        __ivg_info "${__ivg_repo} is up to date."
        return 1
    }

    __ivg_setup_internal() {
        __ivg_info "Start setup ${__ivg_repo}"
        __ivg_do_setup && __ivg_prepare_repo && __ivg_info "End setup ${__ivg_repo}"
    }

    __ivg_setup() {
        __ivg_setup_internal
        __ivg_setup_ret=$?
        if [ $__ivg_setup_ret -ne 0 ];  then
            if __ivg_is_up_to_date ; then
                __ivg_info "End setup, ${__ivg_repo} is already up to date."
            else
                __ivg_error "Setup ${__ivg_repo} failed!"
            fi
        fi
        return $__ivg_setup_ret
    }

    __ivg_rollback_repo() {
        if __ivg_has_change ; then
            __ivg_cd "$__ivg_targetd" && __ivg_git_checkout "$__ivg_current_hash" && __ivg_warn "Rolled back ${__ivg_repo} to ${__ivg_current_hash}"
        fi
    }

    __ivg_rollback_internal() {
        __ivg_warn "Start rollback ${__ivg_repo}"
        __ivg_rollback_repo && __ivg_do_rollback && __ivg_warn "End rollback ${__ivg_repo}"
    }

    __ivg_rollback() {
        __ivg_rollback_internal
        __ivg_rollback_ret=$?
        if [ $__ivg_rollback_ret -ne 0 ]; then
            __ivg_error "Rollback ${__ivg_repo} failed!"
        fi
        return $__ivg_rollback_ret
    }

    __ivg_install() {
        __ivg_info "Start install ${__ivg_repo}"
        __ivg_do_install && __ivg_info "End install ${__ivg_repo}"
    }

    __ivg_on_success() {
        __ivg_info "${__ivg_reponame} successfully installed!"
        __ivg_info "  repo: ${__ivg_repo}"
        __ivg_info "  old: ${__ivg_current_hash}"
        __ivg_info "  new: ${__ivg_next_hash}"
    }

    __ivg_on_failure() {
        __ivg_on_failure_ret=$?
        if __ivg_is_up_to_date ; then
            return 0
        fi
        __ivg_error "Errors were encountered! Status: ${__ivg_on_failure_ret}"
        __ivg_error "Please check commands and ${__ivg_targetd}"
        __ivg_rollback
        return "$__ivg_on_failure_ret"
    }

    __ivg_setup && __ivg_install && __ivg_on_success || __ivg_on_failure
}
