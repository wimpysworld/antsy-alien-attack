#!/usr/bin/env bash

titleMusicThread=
titleScreen=()

title-mode() {
  export KEY=
  export DELAY=0.01
  tput clear

  reset-timers
  music title
  titleMusicThread=$!

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "C O N T R O L S"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "W"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "↑"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "A ←   → D"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "↓"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "S"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "[L] Unleash the lasers"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 9)) " Press [P] to Play or [Q] to Quit"

  readarray -t titleScreen < gfx/title.ans
  titleScreenOffset=$(center 80)

  export LOOP=title-loop
}

title-loop() {
  if [[ $KEY == 'p' ]]; then
    kill-thread $titleMusicThread
    game-mode
  elif [[ $KEY == 'q' ]]; then
    kill-thread $titleMusicThread
    teardown
  else
    wave-picture "$titleScreenOffset" "${titleScreen[@]}"
    render
  fi
}
