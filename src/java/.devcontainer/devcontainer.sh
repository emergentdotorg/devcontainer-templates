#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"


#[ -z "$( git config --get user.email )" ] && [ -n "${GIT_USER_EMAIL}" ] && git config --global user.email "${GIT_USER_EMAIL}"
#[ -z "$( git config --get user.name )" ] && [ -n "${GIT_USER_NAME}" ] && git config --global user.name "${GIT_USER_NAME}"

if [ -z "${DOTFILES_REPO}" ]; then
  echo "DOTFILES_REPO not set!"
  exit 0
fi

DOTFILES_REPO="${DOTFILES_REPO:?DOTFILES_REPO empty or unset}"
DOTFILES_DEST="${DOTFILES_DEST:-${HOME}/.dotfiles}"
DOTFILES_INIT="${DOTFILES_INIT:-install.sh}"

if [ ! -e "${DOTFILES_DEST}" ]; then
  GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" git clone "git@github.com:${DOTFILES_REPO}" ${DOTFILES_DEST}
fi
if [ ! -e "${DOTFILES_DEST}/${DOTFILES_INIT}" ]; then
  echo "No init file found at ${DOTFILES_DEST}/${DOTFILES_INIT}, exiting!"
  exit 1
fi
exec "${DOTFILES_DEST}/${DOTFILES_INIT}"
