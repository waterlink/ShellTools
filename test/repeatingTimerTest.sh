#!/usr/bin/env ../libs/bin/bats

load ../src/repeatingTimer

INTERVAL=120
MESSAGE="some message"

NOTIFICATION=
TIMES_RECEIVED=0
function fakeNotify() {
    [[ "${JUST_SLEPT}" == "true" ]]
    JUST_SLEPT="false"

    NOTIFICATION="$1"
    TIMES_RECEIVED=$((TIMES_RECEIVED + 1))
}

RUNNING_QUEUE="false"
function fakeIsRunning() {
    local head=${RUNNING_QUEUE%% *}
    local tail=${RUNNING_QUEUE#* }
    RUNNING_QUEUE="${tail}"

    [[ "$head" == "true" ]]
}

JUST_SLEPT="false"
SLEPT_FOR=0
TIMES_SLEPT=0
function fakeSleep() {
    SLEPT_FOR="$1"
    TIMES_SLEPT=$((TIMES_SLEPT + 1))
    JUST_SLEPT="true"
}

@test "sends notification" {
    MESSAGE="a notification message"
    RUNNING_QUEUE="true false"
    repeatingTimerGeneric fakeIsRunning fakeSleep fakeNotify "${INTERVAL}" "${MESSAGE}"
    [[ "${NOTIFICATION}" == "${MESSAGE}" ]]
}

@test "sends a different notification" {
    MESSAGE="a different notification message"
    RUNNING_QUEUE="true false"
    repeatingTimerGeneric fakeIsRunning fakeSleep fakeNotify "${INTERVAL}" "${MESSAGE}"
    [[ "${NOTIFICATION}" == "${MESSAGE}" ]]
}

@test "it does not send a notification when not running" {
    repeatingTimerGeneric fakeIsRunning fakeSleep fakeNotify "${INTERVAL}" "some message"
    [[ -z "${NOTIFICATION}" ]]
}

@test "it sends notification 1 time when running queue has 1 'true's in it" {
    RUNNING_QUEUE="true false"

    repeatingTimerGeneric fakeIsRunning fakeSleep fakeNotify "${INTERVAL}" "${MESSAGE}"
    [[ "${TIMES_RECEIVED}" -eq 1 ]]
}

@test "it sends notification 3 times when running queue has 3 'true's in it" {
    RUNNING_QUEUE="true true true false"

    repeatingTimerGeneric fakeIsRunning fakeSleep fakeNotify "${INTERVAL}" "${MESSAGE}"
    [[ "${TIMES_RECEIVED}" -eq 3 ]]
}

@test "it does not sleep when not running" {
    repeatingTimerGeneric fakeIsRunning fakeSleep fakeNotify "${INTERVAL}" "${MESSAGE}"
    [[ "${SLEPT_FOR}" -eq 0 ]]
    [[ "${TIMES_SLEPT}" -eq 0 ]]
}

@test "it sleeps for interval once before notification" {
    RUNNING_QUEUE="true false"
    repeatingTimerGeneric fakeIsRunning fakeSleep fakeNotify "${INTERVAL}" "${MESSAGE}"
    [[ "${SLEPT_FOR}" -eq "${INTERVAL}" ]]
    [[ "${TIMES_SLEPT}" -eq 1 ]]
}

@test "it sleeps for different interval once before notification" {
    INTERVAL=180
    RUNNING_QUEUE="true false"
    repeatingTimerGeneric fakeIsRunning fakeSleep fakeNotify "${INTERVAL}" "${MESSAGE}"
    [[ "${SLEPT_FOR}" -eq "${INTERVAL}" ]]
    [[ "${TIMES_SLEPT}" -eq 1 ]]
}
