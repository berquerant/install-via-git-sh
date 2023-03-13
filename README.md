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
    If 0, cancel installation when no update is required.
    Default is 0.

  IVG_DEBUG:
    If not 0, enable debug logs.
    Default is 0.

  GIT:
    git command.

  IVG_REPOSITORY:
    Required. Repository URI to be installed.

  IVG_REPOSITORY_NAME:
    Required. Repository name to be installed.

  IVG_BRANCH:
    Branch name to be installed. Default is main.

  IVG_COMMIT:
    Commit to be installed. Default is the latest commit of IVG_BRANCH.

  IVG_LOCKFILE:
    File to save commithash.

  IVG_SETUP_COMMAND:
    Setup command.

  IVG_INSTALL_COMMAND:
    Install command.

  IVG_ROLLBACK_COMMAND:
    Rollback command.

  IVG_SKIPPED_COMMAND:
    Command to be executed when update is skipped.

e.g.

. install-via-git.sh
setup() {
...

install() {
...

rollback() {
...

skipped() {
...


export IVG_REPOSITORY="https://github.com/USERNAME/path/to/repo.git"
export IVG_REPOSITORY_NAME="reponame"
export IVG_BRANCH="master"
export IVG_SETUP_COMMAND="setup" # refer setup()
export IVG_INSTALL_COMMAND="install" # refer install()
export IVG_ROLLBACK_COMMAND="rollback" # refer rollback()
export IVG_SKIPPED_COMMAND="skipped" # refer skipped()
ivg_run

then

1. setup()
2. git clone https://github.com/USERNAME/path/to/repo.git $IVG_WORKD/reponame
3. git pull
4. skipped() and exit when no update is required
5. install()

rollback repo and rollback() if errors are occurred.
```
