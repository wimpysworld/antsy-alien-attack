#!/usr/bin/env bash

readonly STATUS_COLOR=$BRED$WHT

reset-game() {
  score=0
  lives=3
  P1_X=$(( (SCREEN_WIDTH) /2 ))
  P1_Y=$(( (SCREEN_HEIGHT) /2 ))
  P1_EndX=$(( SCREEN_WIDTH  - (PLAYER1_WIDTH + 2) ))
  P1_EndY=$(( SCREEN_HEIGHT - PLAYER1_HEIGHT ))
  P1_OldX=$P1_X
  P1_OldY=$P1_Y
  P1_LASERS=()
  P2_LASERS=()
  P1_LASER_CEILING=0
  P2_LASER_CEILING=0
}

game-mode() {
  export KEY=
  export DELAY=0.01
  tput clear

  reset-timers
  reset-game
  music level"$(shuf -i 1-3 -n 1)"
  gameMusicThread=$!
  export LOOP=game-loop
}

player-lasers() {
  local IN_FLIGHT=${#P1_LASERS[@]}
  for (( LASER=0; LASER<${IN_FLIGHT}; LASER++ )); do

    LASER_INSTANCE=(${P1_LASERS[$LASER]})
    LASER_X=${LASER_INSTANCE[0]}
    LASER_Y=${LASER_INSTANCE[1]}

    ((LASER_Y--))

    if [ $LASER_Y -le $P1_LASER_CEILING ]; then
      erase-sprite "$LASER_X" "$LASER_Y" "${P1_LASER_SPRITE[@]}"
      unset P1_LASERS[$LASER]
      P1_LASERS=("${P1_LASERS[@]}")
      ((IN_FLIGHT--))
      continue
    else
      P1_LASERS[$LASER]="$LASER_X $LASER_Y"
    fi
    draw-sprite "$LASER_X" "$LASER_Y" "${P1_LASER_SPRITE[@]}"
  done
}

game-loop() {
  # Movement
  case $KEY in
    'w')
      P1_OldY=$P1_Y
      ((P1_Y--))
      # Prevent leaving the top of the screen
      [ $P1_Y -lt 1 ] && P1_Y=1;;
    's')
      P1_OldY=$P1_Y
      ((P1_Y++))
      # Prevent leaving the bottom of the screen
      [ $P1_Y -gt $P1_EndY ] && P1_Y=$P1_EndY;;
    'a')
      P1_OldX=$P1_X
      ((P1_X--))
      # Prevent leaving screen left
      [ $P1_X -lt 0 ] && P1_X=0;;
    'd')
      P1_OldX=$P1_X
      ((P1_X++))
      # Prevent leaving screne right
      [ $P1_X -gt $P1_EndX ] && P1_X=$P1_EndX;;
    'l')
      sound laser
      P1_LASERS+=("$((P1_X + 3)) $((P1_Y - 1))");;
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
  compose-sprites
  # Score and entities
  draw 0 0 "$STATUS_COLOR" "Lives: $lives"
  draw-right 0 "$STATUS_COLOR" "Score: $score"
  draw-sprite "$P1_X" "$P1_Y" "${PLAYER1[@]}"
  player-lasers
  render
}