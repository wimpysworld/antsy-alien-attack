#!/usr/bin/env bash

export VICTORY_MUSIC_THREAD=

victory-mode() {
  export KEY=
  tput clear

  reset-timers
  music victory
  VICTORY_MUSIC_THREAD=$!

  local VICTORY_SCREEN_OFFSET=
  VICTORY_SCREEN_OFFSET=$(center 59)
  draw-picture "${VICTORY_SCREEN_OFFSET}" 1 victory

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "You defeated the alien horde! Hurray!"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Press [R] to reminisce about the old times or [Q] to Quit"

  export LOOP=victory-loop
}

victory-loop() {
  if [[ $KEY == 'r' ]]; then
    kill-thread ${VICTORY_MUSIC_THREAD}
    title-mode
  elif [[ $KEY == 'q' ]]; then
    kill-thread ${VICTORY_MUSIC_THREAD}
    teardown
  else
    render
  fi
}
