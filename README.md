# install-via-git.sh

```
install-via-git.sh provides that `ivg_run()` to install some tools via git.

Usage:

1. Prepare shell to be executed to install tools.
2. Load this in the shell.
3. Write functions to setup, install and rollback.
4. Call `ivg_run()`.

Environment variables:

  IVG_WORKD:
    Working directory.
    repo will be cloned into $IVG_WORKD/reponame
    reponame is the 2nd argument of `ivg_run()`.
    Default is $PWD.

  IVG_FORCE_UPDATE:
    If 0, cancel installation when `git pull` does not update repo.
    Default is 0.

  IVG_DEBUG:
    If not 0, enable debug logs.
    Default is 0.

  GIT:
    git command.

  IVG_REPOSITORY:
    Repository URI to be installed.
    The 1st argument of ivg_run() is preferentially referenced.

  IVG_REPOSITORY_NAME:
    Repository name to be installed.
    The 2nd argument of ivg_run() is preferentially referenced.

  IVG_BRANCH:
    Branch name to be installed.
    The 3rd argument of ivg_run() is preferentially referenced.

  IVG_SETUP_COMMAND:
    Setup command.
    The 4th argument of ivg_run() is preferentially referenced.

  IVG_INSTALL_COMMAND:
    Install command.
    The 5th argument of ivg_run() is preferentially referenced.

  IVG_ROLLBACK_COMMAND:
    Rollback command.
    The 6th argument of ivg_run() is preferentially referenced.

  IVG_LOCKFILE:
    File to save commithash.
    The 7th argument of ivg_run() is preferentially referenced.

e.g.

. install-via-git.sh
setup() {
...

install() {
...

rollback() {
...

ivg_run "https://github.com/USERNAME/path/to/repo.git" \ # required
        "reponame" \ # required
        "master" \   # branch, required, default is main
        "setup" \    # refer setup(), ignored if empty string
        "install" \  # refer install(), ignored if empty string
        "rollback" \ # refer rollback(), ignored if empty string
        "lockfile"   # file to save commithash, ignored if empty string

then

1. setup()
2. git clone https://github.com/USERNAME/path/to/repo.git $IVG_WORKD/reponame
3. git pull
4. install()

rollback repo and rollback() if errors are occurred.
```
