#!/usr/bin/env ../libs/bin/bats

load ../src/makeTempDir

TMP_DIR_TO_BE_CREATED=
function fakeMakeTemp() {
    echo "${TMP_DIR_TO_BE_CREATED}"
}

TRAPPED=
TRAPPED_ON=
function fakeTrap() {
    TRAPPED="$1"
    TRAPPED_ON="$2"
}

@test "sets provided environment variable to the path of created temporary directory" {
    MY_TEMP_DIR=
    TMP_DIR_TO_BE_CREATED="/path/to/tmp/dir"
    makeTempDirGeneric fakeMakeTemp fakeTrap MY_TEMP_DIR
    [[ "${MY_TEMP_DIR}" == "${TMP_DIR_TO_BE_CREATED}" ]]
}

@test "sets provided environment variable to the path of different created temporary directory" {
    MY_TEMP_DIR=
    TMP_DIR_TO_BE_CREATED="/path/to/different/tmp/dir"
    makeTempDirGeneric fakeMakeTemp fakeTrap MY_TEMP_DIR
    [[ "${MY_TEMP_DIR}" == "${TMP_DIR_TO_BE_CREATED}" ]]
}

@test "sets different provided environment variable to the path of created temporary directory" {
    DIFFERENT_TEMP_DIR=
    TMP_DIR_TO_BE_CREATED="/path/to/tmp/dir"
    makeTempDirGeneric fakeMakeTemp fakeTrap DIFFERENT_TEMP_DIR
    [[ "${DIFFERENT_TEMP_DIR}" == "${TMP_DIR_TO_BE_CREATED}" ]]
}

@test "it traps removal of that temporary directory" {
    TMP_DIR_TO_BE_CREATED="/path/to/tmp/dir"
    makeTempDirGeneric fakeMakeTemp fakeTrap MY_TEMP_DIR
    [[ "${TRAPPED}" == "rm -rf ${TMP_DIR_TO_BE_CREATED}" ]]
    [[ "${TRAPPED_ON}" == "EXIT" ]]
}

@test "it traps removal of different temporary directory" {
    TMP_DIR_TO_BE_CREATED="/path/to/different/tmp/dir"
    makeTempDirGeneric fakeMakeTemp fakeTrap MY_TEMP_DIR
    [[ "${TRAPPED}" == "rm -rf ${TMP_DIR_TO_BE_CREATED}" ]]
    [[ "${TRAPPED_ON}" == "EXIT" ]]
}