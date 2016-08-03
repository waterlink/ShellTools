#!/usr/bin/env bash

function repeatingTimerGeneric() {
    local isRunning="$1"
    local sleep="$2"
    local notify="$3"
    local interval="$4"
    local message="$5"

    while ${isRunning}; do
        ${sleep} "${interval}"
        ${notify} "${message}"
    done
}

function repeatingTimer() {
    repeatingTimerGeneric alwaysRunning sleepFunc notify "$@"
}

function alwaysRunning() {
    true
}

function sleepFunc() {
    sleep "$@"
}

function notify() {
    notify-send --expire-time 700 "$@"
}