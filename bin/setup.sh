#!/usr/bin/env bash

set -e

source "./src/installBats.bash"
source "./src/makeSureDirIsPresent.bash"
source "./src/exists.bash"
source "./src/makeRepoSafe.bash"

BATS_GIT_URL="https://github.com/sstephenson/bats.git"
LIBS_DIR="${PWD}/libs"
MY_TMP_DIR=

function makeTempDir() {
    local varName="$1"
    eval "${varName}=$(mktemp -d)"
    trap "rm -rf \${${varName}}" EXIT
}

makeTempDir MY_TMP_DIR
makeSureDirIsPresent "${LIBS_DIR}"
installBats "${BATS_GIT_URL}" "${MY_TMP_DIR}" "${LIBS_DIR}"
makeRepoSafe ".." ".git/safe"