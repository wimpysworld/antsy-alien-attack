#!/usr/bin/env bash

titleSoundThread=
titleScreen=()

# for A in $(seq 0 36); do perl -e "printf '%.0f ', cos($A / 3) * 3"; done
sin=(3 3 2 2 1 -0 -1 -2 -3 -3 -3 -3 -2 -1 -0 1 2 2 3 3 3 2 1 1 -0 -1 -2 -3 -3 -3 -3 -2 -1 0 1 2 3)
sinc=${#sin[@]}

title-mode() {
  KEY=
  DELAY=0
  tput clear

  music title
  titleMusicThread=$!

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "C O N T R O L S"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "W"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "A  🎮  D"  
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "S" 
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) " Press 🇵  to Play or 🇶  to Quit"

  readarray -t titleScreen < gfx/title.ans
  titleScreenOffset=$(center 80)

  LOOP=title-loop
}

title-loop() {
  if [[ $KEY == 'p' ]]; then
    kill-thread $titleMusicThread
    game-mode
  elif [[ $KEY == 'q' ]]; then
    kill-thread $titleMusicThread
    teardown
  else
    local y=1
    for line in "${titleScreen[@]}"; do
      local i=$(((frame / 2 + y) % sinc))
      local x=$((titleScreenOffset + sin["$i"]))
      draw $x $y 0 "\e[1K$line\e[K"
      ((y++))
    done
    render
  fi
}