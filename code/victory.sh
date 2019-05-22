#!/usr/bin/env bash

victory-mode() {
  export KEY=
  export VICTORY_MUSIC_THREAD=
  export VICTORY_SCREEN=()
  export VICTORY_SCREEN_OFFSET=
  blank-screen

  reset-timers
  music victory
  VICTORY_MUSIC_THREAD=$!
  sound mission_completed congratulations

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "You defeated the alien horde! Hurray!"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Press [R] to reminisce about the old times or [Q] to Quit"

  readarray -t VICTORY_SCREEN < gfx/victory.ans
  VICTORY_SCREEN_LONGEST_LINE=$(wc -L gfx/victory.txt | cut -d' ' -f1)
  VICTORY_SCREEN_OFFSET=$(center ${VICTORY_SCREEN_LONGEST_LINE})

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
    wave-picture "${VICTORY_SCREEN_OFFSET}" "${VICTORY_SCREEN[@]}"
    render
  fi
}
