#!/usr/bin/env ../libs/bin/bats

source ../src/makeRepoSafe.bash

EXPECTED_EXISTS=
function fakeExists() {
    [[ "${EXPECTED_EXISTS}" == "$1" ]]
}

LINKED_FROM=
LINKED_TO=
function fakeLink() {
    LINKED_FROM="$1"
    LINKED_TO="$2"
}

@test "makes link if not exists" {
    EXPECTED_EXISTS="whatever"

    makeRepoSafeGeneric fakeExists fakeLink "a/source/dir" "the/destination"

    [[ "${LINKED_FROM}" == "a/source/dir" ]]
    [[ "${LINKED_TO}" == "the/destination" ]]
}

@test "makes different link if not exists" {
    EXPECTED_EXISTS="whatever"

    makeRepoSafeGeneric fakeExists fakeLink "a/different/source/dir" "another/destination"

    [[ "${LINKED_FROM}" == "a/different/source/dir" ]]
    [[ "${LINKED_TO}" == "another/destination" ]]
}

@test "does not make link if exists" {
    LINKED_FROM=
    EXPECTED_EXISTS="the/destination"

    makeRepoSafeGeneric fakeExists fakeLink "a/source/dir" "the/destination"

    [[ -z "${LINKED_FROM}" ]]
}

@test "does not make different link if exists" {
    LINKED_FROM=
    EXPECTED_EXISTS="another/destination"

    makeRepoSafeGeneric fakeExists fakeLink "a/source/dir" "another/destination"

    [[ -z "${LINKED_FROM}" ]]
}