#!/usr/bin/env bash

gameoverMusicThread=

gameover-mode() {
  export KEY=
  tput clear

  music gameover
  gameoverMusicThread=$!

  local gameoverScreenOffset=$(center 73)
  draw-picture "$gameoverScreenOffset" 1 gameover

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "You failed! But you may try again."
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Press 🇷  to seek revenge or 🇶  to Quit"

  export LOOP=gameover-loop
}

gameover-loop() {
  if [[ $KEY == 'r' ]]; then
    kill-thread $gameoverMusicThread
    title-mode
  elif [[ $KEY == 'q' ]]; then
    kill-thread $gameoverMusicThread
    teardown
  else
    render
  fi
}