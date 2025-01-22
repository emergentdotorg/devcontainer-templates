#!/bin/bash

# -e: exit on error
# -u: exit on unset variables
set -eu

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

declare subcmd="$1"
shift
case "$subcmd" in
  docs)
    GITHUB_TOKEN="$CR_PAT" devcontainer templates generate-docs \
      --github-owner=emergentdotorg \
      --github-repo=devcontainer-templates \
      -p "${script_dir}/src"
      "$@"
    ;;
  publish)
    GITHUB_TOKEN="$CR_PAT" devcontainer templates publish \
      -r ghcr.io -n emergentdotorg/devcontainer-templates \
      --log-level debug \
      ./src "$@"
    ;;
  *)
    echo "Unknown subcommand"
    ;;
esac


exit 0

## applying old

devcontainer templates apply -w . -t ghcr.io/devcontainers/templates/java:latest \
   -a '{ "imageVariant": "8-bookworm" }' \
   -f '[{ "id": "ghcr.io/devcontainers/features/java:1", "options": { "installMaven": true } }]'

## applying new

#  -f '[{ "id": "ghcr.io/devcontainers/features/java:1", "options": { "installMaven": true, "installGradle": true } }]' \
GITHUB_TOKEN="$CR_PAT" devcontainer templates apply -t ghcr.io/emergentdotorg/devcontainer-templates/java:latest \
  -a '{ "imageVariant": "8-bookworm" }' \
  -a '{ "installMaven": true, "installGradle": true }' \
  -w .

GITHUB_TOKEN="$CR_PAT" devcontainer templates apply \
  -a '{ "imageVariant": "8-bookworm", "installMaven": true, "installGradle": true }' \
  -w . -t ghcr.io/emergentdotorg/devcontainer-templates/java:1.1
