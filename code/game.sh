#!/usr/bin/env bash

readonly STATUS_COLOR=$BRED$WHT

reset-game() {
  score=0
  lives=3
  heroX=$(( (SCREEN_WIDTH) /2 ))
  heroY=$(( (SCREEN_HEIGHT) /2 ))
  heroEndX=$(( SCREEN_WIDTH  - (${#HERO[0]} + 2) ))
  heroEndY=$(( SCREEN_HEIGHT - ${#HERO[@]} ))
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
      ((heroY--))
      # Prevent leaving the top of the screen
      [ $heroY -lt 1 ] && heroY=1;;
    's')
      oldheroY=$heroY
      ((heroY++))
      # Prevent leaving the bottom of the screen
      [ $heroY -gt $heroEndY ] && heroY=$heroEndY;;
    'a')
      oldheroX=$heroX
      ((heroX--))
      # Prevent leaving screen left
      [ $heroX -lt 0 ] && heroX=0;;
    'd')
      oldheroX=$heroX
      ((heroX++))
      # Prevent leaving screne right
      [ $heroX -gt $heroEndX ] && heroX=$heroEndX;;
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