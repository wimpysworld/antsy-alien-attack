#!/usr/bin/env bash

victoryMusicThread=

victory-mode() {
  export KEY=
  export DELAY=0
  tput clear

  reset-timers
  music victory
  victoryMusicThread=$!

  local victoryScreenOffset=$(center 59)
  draw-picture "$victoryScreenOffset" 1 victory

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "You defeated the alien horde! Hurray!"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Press [R] to reminisce about the old times or [Q] to Quit"

  export LOOP=victory-loop
}

victory-loop() {
  if [[ $KEY == 'r' ]]; then
    kill-thread $victoryMusicThread
    title-mode
  elif [[ $KEY == 'q' ]]; then
    kill-thread $victoryMusicThread
    teardown
  else
    render
  fi
}