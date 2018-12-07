#!/usr/bin/env bash

readonly STATUS_COLOR=$BRED$WHT
readonly HERO='🐧'
heroX=$(($(tput cols)/2))
heroY=$(($(tput lines)/2))
oldheroX=$heroX
oldheroY=$heroY
heroSize=${#HERO}

reset-game() {
  score=0
  lives=3
}

game-mode() {
  KEY=
  DELAY=0.05
  tput clear
  reset-game
  music level$(shuf -i 1-3 -n 1)
  gameMusicThread=$!
  LOOP=game-loop
}

game-loop() {
  erase $heroX $heroY $heroSize

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
  draw 0 0 $STATUS_COLOR "Lives: $lives"
  draw-right 0 $STATUS_COLOR "Score: $score"
  draw $heroX $heroY $DEF "$HERO"
  render
}