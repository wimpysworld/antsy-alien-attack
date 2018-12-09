#!/usr/bin/env bash

export KEY=

joystickThread=
joy2key=$(command -v joy2key)

joystick-setup() {
  # Is joy2key in the path and is there joystick connected
  if [ -n "$joy2key" ] && [ -c /dev/input/js0 ]; then
    $joy2key -rcfile cfg/xbox360.cfg > /dev/null 2>&1 &
    joystickThread=$!
  fi
}

joystick-teardown() {
  if [ -n "$joystickThread" ]; then
    kill-thread $joystickThread
  fi
}

start-input-handler() {
  while :; do
    read -rsn1 KEY 2>/dev/null
  done
}