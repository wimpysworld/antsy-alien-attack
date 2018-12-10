#!/usr/bin/env bash

readonly STATUS_COLOR=$BRED$WHT

reset-game() {
  score=0
  lives=3
  heroX=$(( (SCREEN_WIDTH) /2 ))
  heroY=$(( (SCREEN_HEIGHT) /2 ))
  oldheroX=$heroX
  oldheroY=$heroY
}

game-mode() {
  export KEY=
  export DELAY=0.05
  tput clear
  reset-game
  music level"$(shuf -i 1-3 -n 1)"
  gameMusicThread=$!
  export LOOP=game-loop
}

game-loop() {
  # Movement
  case $KEY in
    'w')
      oldheroY=$heroY
      ((heroY--));;
    's')
      oldheroY=$heroY
      ((heroY++));;
    'a')
      oldheroX=$heroX
      ((heroX--));;
    'd')
      oldheroX=$heroX
      ((heroX++));;
    'l')
      sound laser;;
    'v')
      # Victory condition stub
      kill-thread "$gameMusicThread"
      victory-mode
      return 1;;
    'o')
      # Game over condition stub
      kill-thread "$gameMusicThread"
      gameover-mode
      return 1;;
  esac
  KEY=

  # Score and entities
  draw 0 0 "$STATUS_COLOR" "Lives: $lives"
  draw-right 0 "$STATUS_COLOR" "Score: $score"
  draw-sprite "$heroX" "$heroY" "${HERO[@]}"
  render
}