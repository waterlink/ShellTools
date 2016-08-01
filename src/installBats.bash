#!/usr/bin/env bash

function installBatsGeneric() {
    local gitClone="$1"
    local install="$2"
    local cd="$3"
    local pwd="$4"
    local which="$5"
    local gitUrl="$6"
    local tmpDir="$7"
    local libsDir="$8"

    local originalDir=$(${pwd})
    local batsDir="${tmpDir}/bats"

    if ! ${which} "bats" >/dev/null; then
        ${gitClone} "${gitUrl}" "${batsDir}"
        ${cd} "${batsDir}"
        ${install} "./install.sh" "${libsDir}"
        ${cd} "${originalDir}"
    fi
}

function installBats() {
    installBatsGeneric gitClone "" cd pwd which "$@"
}

function gitClone() {
    git clone "$@"
}