#!/usr/bin/env bash

readonly STATUS_COLOR=$BRED$WHT

reset-game() {
  P1_SCORE=0
  P2_SCORE=0
  P1_LIVES=3
  P3_LIVES=3
  P1_X=$(( (SCREEN_WIDTH - P1_WIDTH) / 2 ))
  P1_Y=$(( SCREEN_HEIGHT - P1_HEIGHT ))
  P1_MAX_X=$(( SCREEN_WIDTH  - (P1_WIDTH + 2) ))
  P1_MAX_Y=$(( SCREEN_HEIGHT - P1_HEIGHT ))
  P1_LASERS=()
  P2_LASERS=()
  P1_LASER_CEILING=0
  P2_LASER_CEILING=0
  P1_RECENTLY_FIRED=0
  P2_RECENTLY_FIRED=0
  P1_LASER_LATENCY=6
  P2_LASER_LATENCY=6
  P1_LAST_KEY=
  P2_LAST_KEY=
  FIGHTERS=()
  MAX_FIGHTERS=1
  FIGHTER_MAX_X=$(( SCREEN_WIDTH  - (FIGHTER_WIDTH + 2) ))
  FIGHTER_MAX_Y=$(( SCREEN_HEIGHT  - FIGHTER_HEIGHT ))
  readonly FIGHTER_FLOOR=$((SCREEN_HEIGHT + FIGHTER_HEIGHT))
  FIGHTER_ANIM_SPEED=0
  FIGHTER_CURRENT_SPEED=10
  FIGHTER_SPAWN_DELAY=0
  FIGHTER_MAX_SPAWN_DELAY=100
  create-starfield
}

game-mode() {
  export KEY=
  export DELAY=0.01
  tput clear

  reset-timers
  reset-game
  music level"$(shuf -i 1-3 -n 1)"
  GAME_MUSIC_THREAD=$!
  export LOOP=game-loop
}

spawn-fighter() {
  local SPAWN_Y=0
  local SPAWN_X=
  SPAWN_X=$(shuf -i 0-$FIGHTER_MAX_X -n 1)
  FIGHTERS+=("$SPAWN_X $SPAWN_Y")
}

fighter-ai() {
  local IN_FLIGHT=${#FIGHTERS[@]}
  local FIGHTER=0
  if ((IN_FLIGHT < MAX_FIGHTERS && FIGHTER_SPAWN_DELAY == 0)); then
    spawn-fighter
    ((IN_FLIGHT++))
  fi

  for (( FIGHTER=0; FIGHTER < IN_FLIGHT; FIGHTER++ )); do
    local FIGHTER_INSTANCE=(${FIGHTERS[${FIGHTER}]})
    local FIGHTER_X=${FIGHTER_INSTANCE[0]}
    local FIGHTER_Y=${FIGHTER_INSTANCE[1]}

    if ((FIGHTER_ANIM_SPEED == 0)); then
      if ((FIGHTER_Y > FIGHTER_FLOOR)); then
        # Remove the fighter
        erase-sprite 1 "$FIGHTER_X" "$FIGHTER_Y" "${FIGHTER_SPRITE[@]}"
        unset FIGHTERS[${FIGHTER}]
        FIGHTERS=("${FIGHTERS[@]}")
        ((IN_FLIGHT--))
        continue
      else
        ((FIGHTER_Y++))
        FIGHTERS[$FIGHTER]="$FIGHTER_X $FIGHTER_Y"
      fi
    fi
    draw-sprite 1 "$FIGHTER_X" "$FIGHTER_Y" "${FIGHTER_SPRITE[@]}"
  done

  # Increment the fighter movement
  [[ $FIGHTER_ANIM_SPEED -ge $FIGHTER_CURRENT_SPEED ]] && FIGHTER_ANIM_SPEED=0 || ((FIGHTER_ANIM_SPEED++))

  # Increant the fighter spawn delay
  [[ $FIGHTER_SPAWN_DELAY -ge $FIGHTER_MAX_SPAWN_DELAY ]] && FIGHTER_SPAWN_DELAY=0 || ((FIGHTER_SPAWN_DELAY++))
}

check-laser-impact-fighter() {
  local LASER_X=$1
  local LASER_Y=$2
  local IN_FLIGHT=${#FIGHTERS[@]}
  local FIGHTER=0
  for (( FIGHTER=0; FIGHTER < IN_FLIGHT; FIGHTER++ )); do
    local FIGHTER_INSTANCE=(${FIGHTERS[${FIGHTER}]})
    local FIGHTER_X=${FIGHTER_INSTANCE[0]}
    local FIGHTER_Y=${FIGHTER_INSTANCE[1]}
    if ((LASER_X >= FIGHTER_X && LASER_X <= FIGHTER_X + FIGHTER_WIDTH)); then
      if ((LASER_Y >= FIGHTER_Y && LASER_Y <= FIGHTER_Y + FIGHTER_HEIGHT)); then
        # Remove the fighter
        sound fighter-explosion
        erase-sprite 1 "$FIGHTER_X" "$FIGHTER_Y" "${FIGHTER_SPRITE[@]}"
        unset FIGHTERS[${FIGHTER}]
        FIGHTERS=("${FIGHTERS[@]}")
        ((IN_FLIGHT--))
        return 0
      fi
    fi
  done
  return 1
}

player-lasers() {
  local IN_FLIGHT=${#P1_LASERS[@]}
  for (( LASER=0; LASER < IN_FLIGHT; LASER++ )); do

    local LASER_INSTANCE=(${P1_LASERS[${LASER}]})
    local LASER_X=${LASER_INSTANCE[0]}
    local LASER_Y=${LASER_INSTANCE[1]}

    if ((LASER_Y <= P1_LASER_CEILING)); then
      erase-sprite 0 "$LASER_X" "$LASER_Y" "${P1_LASER_SPRITE[@]}"
      unset P1_LASERS[${LASER}]
      P1_LASERS=("${P1_LASERS[@]}")
      ((IN_FLIGHT--))
      continue
    elif check-laser-impact-fighter "${LASER_X}" "${LASER_Y}"; then
      erase-sprite 0 "$LASER_X" "$LASER_Y" "${P1_LASER_SPRITE[@]}"
      unset P1_LASERS[${LASER}]
      P1_LASERS=("${P1_LASERS[@]}")
      ((P1_SCORE++))
      ((IN_FLIGHT--))
      continue
    else
      ((LASER_Y--))
      P1_LASERS[$LASER]="$LASER_X $LASER_Y"
    fi
    draw-sprite 0 "$LASER_X" "$LASER_Y" "${P1_LASER_SPRITE[@]}"
  done
}

game-loop() {
  # Movement
  case $KEY in
    'w')
      ((P1_Y--))
      # Prevent leaving the top of the screen
      [ $P1_Y -lt 1 ] && P1_Y=1
      P1_LAST_KEY=$KEY
      ;;
    's')
      ((P1_Y++))
      # Prevent leaving the bottom of the screen
      [ $P1_Y -gt $P1_MAX_Y ] && P1_Y=$P1_MAX_Y
      P1_LAST_KEY=$KEY
      ;;
    'a')
      ((P1_X--))
      # Prevent leaving screen left
      [ $P1_X -lt 0 ] && P1_X=0
      P1_LAST_KEY=$KEY
      ;;
    'd')
      ((P1_X++))
      # Prevent leaving screne right
      [ $P1_X -gt $P1_MAX_X ] && P1_X=$P1_MAX_X
      P1_LAST_KEY=$KEY
      ;;
    'l')
      if ((P1_RECENTLY_FIRED == 0 )); then
        sound laser
        P1_LASERS+=("$((P1_X + 4)) $((P1_Y - 1))")
        ((P1_RECENTLY_FIRED+=P1_LASER_LATENCY))
      fi
      P1_LAST_KEY=$KEY
      ;;
    'v')
      # Victory condition stub
      kill-thread ${GAME_MUSIC_THREAD}
      victory-mode
      return 1;;
    'o')
      # Game over condition stub
      kill-thread ${GAME_MUSIC_THREAD}
      gameover-mode
      return 1;;
  esac
  KEY=

  # Regulate Player 1 laser fire frequency
  if [ "$P1_LAST_KEY" != 'l' ]; then
    P1_RECENTLY_FIRED=0
  elif ((P1_RECENTLY_FIRED > 0)); then
    ((P1_RECENTLY_FIRED--))
  fi

  compose-sprites
  animate-starfield
  draw 0 0 "$STATUS_COLOR" "Lives: $P1_LIVES"
  draw-right 0 "$STATUS_COLOR" "Score: $P1_SCORE"
  draw-sprite 1 "$P1_X" "$P1_Y" "${P1_SPRITE[@]}"
  fighter-ai
  player-lasers
  render
}