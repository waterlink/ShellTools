#!/usr/bin/env bash

function makeSureDirIsPresentGeneric() {
    local execute="$1"
    local dir="$2"

    local makeDirectory="mkdir"
    local createIfNotExists="-p"

    ${execute} ${makeDirectory} ${createIfNotExists} "${dir}"
}

function makeSureDirIsPresent() {
    makeSureDirIsPresentGeneric "" "$@"
}