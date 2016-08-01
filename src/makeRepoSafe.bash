#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/exists.bash"

function makeRepoSafeGeneric() {
    local exists="$1"
    local link="$2"
    local source="$3"
    local destination="$4"

    if ! ${exists} "${destination}"; then
        ${link} "${source}" "${destination}"
    fi
}

function makeRepoSafe() {
    makeRepoSafeGeneric exists link "$@"
}

function link() {
    ln -s "$@"
}