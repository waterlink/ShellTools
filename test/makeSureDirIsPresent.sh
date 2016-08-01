#!/usr/bin/env ../libs/bin/bats

load ../src/makeSureDirIsPresent

ARG0=
ARG1=
ARG2=
function fakeExecute() {
    ARG0="$1"
    ARG1="$2"
    ARG2="$3"
}

@test "it creates directory" {
    makeSureDirIsPresentGeneric fakeExecute "some/dir"

    [[ "${status}" -eq 0 ]]
    [[ "${ARG0}" == "mkdir" ]]
    [[ "${ARG1}" == "-p" ]]
    [[ "${ARG2}" == "some/dir" ]]
}

@test "it creates different directory" {
    makeSureDirIsPresentGeneric fakeExecute "some/other/dir"

    [[ "${status}" -eq 0 ]]
    [[ "${ARG0}" == "mkdir" ]]
    [[ "${ARG1}" == "-p" ]]
    [[ "${ARG2}" == "some/other/dir" ]]
}