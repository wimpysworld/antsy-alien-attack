#!/usr/bin/env bash

export TITLE_MUSIC_THREAD=
export TITLE_SCREEN=()

title-mode() {
  export KEY=
  export DELAY=0.01
  tput clear

  reset-timers
  music title
  TITLE_MUSIC_THREAD=$!

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "C O N T R O L S"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "W"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "↑"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "A ←   → D"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "↓"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "S"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "[L] Unleash the lasers"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 9)) " Press [P] to Play or [Q] to Quit"

  readarray -t TITLE_SCREEN < gfx/title.ans
  TITLE_SCREEN_OFFSET=
  TITLE_SCREEN_OFFSET=$(center 80)

  export LOOP=title-loop
}

title-loop() {
  if [[ $KEY == 'p' ]]; then
    kill-thread ${TITLE_MUSIC_THREAD}
    game-mode
  elif [[ $KEY == 'q' ]]; then
    kill-thread ${TITLE_MUSIC_THREAD}
    teardown
  else
    wave-picture "${TITLE_SCREEN_OFFSET}" "${TITLE_SCREEN[@]}"
    render
  fi
}
