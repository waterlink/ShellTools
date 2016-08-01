#!/usr/bin/env ../libs/bin/bats

load ../src/exists

EXPECTED_EXISTS=
ARG1=
function fakeTest() {
    ARG1="$1"
    [[ "${EXPECTED_EXISTS}" == "$2" ]]
}

@test "it succeeds when exists" {
    EXPECTED_EXISTS="some/file"

    existsGeneric fakeTest "some/file"

    [[ "${status}" -eq 0 ]]
    [[ "${ARG1}" == "-e" ]]
}

@test "it fails when does not exists" {
    EXPECTED_EXISTS="some/other/file"

    run existsGeneric fakeTest "some/file"

    [[ "${status}" -ne 0 ]]
}