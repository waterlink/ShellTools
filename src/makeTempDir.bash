#!/usr/bin/env bash

function makeTempDirGeneric() {
    local makeTemp="$1"
    local trap="$2"
    local varName="$3"

    local tmpDir=$(${makeTemp})

    eval "${varName}=\"$tmpDir\""
    ${trap} "rm -rf ${tmpDir}" EXIT
}

function makeTempDir() {
    makeTempDirGeneric makeTemp trapFunc "$@"
}

function makeTemp() {
    mktemp -d
}

function trapFunc() {
    trap "$@"
}