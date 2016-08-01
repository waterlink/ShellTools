#!/usr/bin/env ../libs/bin/bats

load ../src/installBats

ORIGINAL_DIR="/original/directory"

CURRENT_DIR="/unknown"
function fakeCd() {
    CURRENT_DIR="$1"
}
function fakePwd() {
    echo "${CURRENT_DIR}"
}

CLONED_TO=
CLONED_FROM=
function fakeGitClone() {
    CLONED_FROM="$1"
    CLONED_TO="$2"
}

INSTALLED_FROM=
INSTALLED_TO=
INSTALLED_USING=
function fakeInstall() {
    INSTALLED_FROM="${CURRENT_DIR}"
    INSTALLED_USING="$1"
    INSTALLED_TO="$2"
}

EXPECTED_WHICH=
function fakeWhich() {
    [[ "${EXPECTED_WHICH}" == "$1" ]] && echo "/path/to/bats"
}

@test "clones from GIT_URL to MY_TMP_DIR/bats" {
    MY_TMP_DIR="/my/tmp/dir"
    GIT_URL="https://git-server.example.org/bats.git"

    installBatsGeneric fakeGitClone fakeInstall fakeCd fakePwd fakeWhich "${GIT_URL}" "${MY_TMP_DIR}" "${LIBS_DIR}"

    [[ "${CLONED_TO}" == "${MY_TMP_DIR}/bats" ]]
    [[ "${CLONED_FROM}" == "${GIT_URL}" ]]
}

@test "clones from different GIT_URL to different MY_TMP_DIR/bats" {
    MY_TMP_DIR="/my/different/tmp/dir"
    GIT_URL="https://different-server.example.org/bats.git"

    installBatsGeneric fakeGitClone fakeInstall fakeCd fakePwd fakeWhich "${GIT_URL}" "${MY_TMP_DIR}" "${LIBS_DIR}"

    [[ "${CLONED_TO}" == "${MY_TMP_DIR}/bats" ]]
    [[ "${CLONED_FROM}" == "${GIT_URL}" ]]
}

@test "installs bats from MY_TMP_DIR/bats to LIBS_DIR using ./install.sh" {
    MY_TMP_DIR="/my/tmp/dir"
    LIBS_DIR="/my/libs/dir"

    installBatsGeneric fakeGitClone fakeInstall fakeCd fakePwd fakeWhich "${GIT_URL}" "${MY_TMP_DIR}" "${LIBS_DIR}"

    [[ "${INSTALLED_FROM}" == "${MY_TMP_DIR}/bats" ]]
    [[ "${INSTALLED_TO}" == "${LIBS_DIR}" ]]
    [[ "${INSTALLED_USING}" == "./install.sh" ]]
}

@test "installs bats from different MY_TMP_DIR/bats to different LIBS_DIR using ./install.sh" {
    MY_TMP_DIR="/different/my/tmp/dir"
    LIBS_DIR="/my/different/libs/dir"

    installBatsGeneric fakeGitClone fakeInstall fakeCd fakePwd fakeWhich "${GIT_URL}" "${MY_TMP_DIR}" "${LIBS_DIR}"

    [[ "${INSTALLED_FROM}" == "${MY_TMP_DIR}/bats" ]]
    [[ "${INSTALLED_TO}" == "${LIBS_DIR}" ]]
    [[ "${INSTALLED_USING}" == "./install.sh" ]]
}

@test "returns to the original directory" {
    CURRENT_DIR="${ORIGINAL_DIR}"

    installBatsGeneric fakeGitClone fakeInstall fakeCd fakePwd fakeWhich "${GIT_URL}" "${MY_TMP_DIR}" "${LIBS_DIR}"

    [[ "${CURRENT_DIR}" == "${ORIGINAL_DIR}" ]]
}

@test "does not install bats if already installed" {
    CURRENT_DIR="${ORIGINAL_DIR}"
    CLONED_FROM=
    INSTALLED_FROM=
    EXPECTED_WHICH=bats

    installBatsGeneric fakeGitClone fakeInstall fakeCd fakePwd fakeWhich "${GIT_URL}" "${MY_TMP_DIR}" "${LIBS_DIR}"

    [[ -z "${CLONED_FROM}" ]]
    [[ -z "${INSTALLED_FROM}" ]]
    [[ "${CURRENT_DIR}" == "${ORIGINAL_DIR}" ]]
}

@test "does not output path to bats when already installed" {
    EXPECTED_WHICH=bats

    run installBatsGeneric fakeGitClone fakeInstall fakeCd fakePwd fakeWhich "${GIT_URL}" "${MY_TMP_DIR}" "${LIBS_DIR}"

    [[ -z "${output}" ]]
}