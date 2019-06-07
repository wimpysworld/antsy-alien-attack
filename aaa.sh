#!/usr/bin/env bash

source cfg/config.sh
source code/threads.sh
source code/input.sh
source code/gfx.sh
source gfx/sprites.sh
source code/sfx.sh
source code/music.sh
source code/title.sh
source code/game.sh
source code/gameover.sh
source code/victory.sh

export LOOP=

setup() {
  music-teardown
  cfg-load
  gfx-setup
  trap teardown EXIT INT TERM
  trap start-loop USR1
  sound-setup
  music-setup
  joystick-setup
}

teardown() {
  cfg-save
  gfx-teardown
  sound-teardown
  music-teardown
  joystick-teardown
  terminate-all-threads
  trap exit USR1
  sleep "${DELAY}"
  exit
}

start-loop() {
  ${LOOP}
  (sleep "${DELAY}" && kill -USR1 $$) &
}

case ${BASH_VERSINFO[@]::2} in [1-3]' '[0-9][0-9]|[1-3]' '[0-9]|'4 '[0-1])
  echo -e "\nYour Bash version is too old! Bash 4.2+ is required to run this game, you have ${BASH_VERSION} installed."
  exit 1;;
esac

setup
title-mode
start-loop
start-input-handler