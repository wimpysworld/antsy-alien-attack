#!/usr/bin/env bash

source code/threads.sh
source code/input.sh
source code/gfx.sh
source code/sfx.sh
source code/music.sh
source code/title.sh
source code/game.sh
source code/gameover.sh
source code/victory.sh

LOOP=
DELAY=0.05

case ${BASH_VERSINFO[@]::2} in [1-3]' '[0-9][0-9]|[1-3]' '[0-9]|'4 '[0-1])
	echo -e "\nYour Bash is too low! 4.2+ is required to run this game, yours is ${BASH_VERSINFO[@]}"
    exit 1;;
esac

setup() {
  trap teardown EXIT INT TERM
  trap start-loop USR1
  gfx-setup
  sound-setup
  music-setup
  joystick-setup
}

teardown() {
  gfx-teardown
  sound-teardown
  music-teardown
  joystick-teardown
  terminate-all-threads
  trap exit USR1
  sleep "$DELAY"
  exit
}

start-loop() {
  $LOOP
  (sleep $DELAY && kill -USR1 $$) &
}

setup
title-mode
start-loop
start-input-handler