#!/usr/bin/env bash

export THREADS=()

keep-thread() {
  local PID=$!
  THREADS+=("${PID}")
  echo ${PID}
}

kill-thread() {
  local PID=${1}
  (kill -KILL "${PID}" || true) > /dev/null 2>&1
}

terminate-all-threads() {
  local LOOP=0
  for LOOP in "${!THREADS[@]}"; do
    kill-thread "${THREADS["${LOOP}"]}"
    unset THREADS["${LOOP}"]
  done
  THREADS=()
}