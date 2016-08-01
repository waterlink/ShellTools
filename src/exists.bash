#!/usr/bin/env bash

function existsGeneric() {
    local test="$1"
    local file="$2"

    ${test} -e "${file}"
}

function exists() {
    existsGeneric test "$@"
}