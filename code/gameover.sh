#!/usr/bin/env bash

gameover-mode() {
  export KEY=
  export GAMEOVER_MUSIC_THREAD=
  export GAMEOVER_SCREEN=()
  export GAMEOVER_SCREEN_OFFSET=

  blank-screen
  reset-timers
  music gameover
  GAMEOVER_MUSIC_THREAD=$!

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "You failed! But you may try again."
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Press [R] to seek revenge or [Q] to Quit"

  readarray -t GAMEOVER_SCREEN < gfx/gameover.ans
  GAMEOVER_SCREEN_OFFSET=$(center 73)

  export LOOP=gameover-loop
}

gameover-loop() {
  if [[ $KEY == 'r' ]]; then
    kill-thread ${GAMEOVER_MUSIC_THREAD}
    title-mode
  elif [[ $KEY == 'q' ]]; then
    kill-thread ${GAMEOVER_MUSIC_THREAD}
    teardown
  else
    wave-picture "${GAMEOVER_SCREEN_OFFSET}" "${GAMEOVER_SCREEN[@]}"
    render
  fi
}
