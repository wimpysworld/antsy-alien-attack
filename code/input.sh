#!/usr/bin/env bash

export KEY=
export JOYSTICK_THREAD=

joystick-setup() {
  local JOY2KEY=$(command -v joy2key)
  # Is joy2key in the path and is there joystick connected
  if [ -n "${JOY2KEY}" ] && [ -c /dev/input/js0 ]; then
    ${JOY2KEY} -rcfile cfg/xbox360.cfg > /dev/null 2>&1 &
    JOYSTICK_THREAD=$!
  fi
}

joystick-teardown() {
  if [ -n "${JOYSTICK_THREAD}" ]; then
    kill-thread ${JOYSTICK_THREAD}
  fi
}

start-input-handler() {
  while :; do
    read -sn1 KEY 2>/dev/null
  done
}