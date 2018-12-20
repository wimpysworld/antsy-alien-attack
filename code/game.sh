#!/usr/bin/env bash

readonly STATUS_COLOR=$BRED$WHT

reset-game() {
  LEVEL=0
  P1_SCORE=0
  P2_SCORE=0
  P1_LIVES=3
  P3_LIVES=3
  P1_KILLS=0
  P2_KILLS=0
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
  FIGHTER_MAX_Y=$(( SCREEN_HEIGHT - FIGHTER_HEIGHT ))
  readonly FIGHTER_FLOOR=$((SCREEN_HEIGHT + FIGHTER_HEIGHT))
  FIGHTER_ANIM_SPEED=0
  FIGHTER_CURRENT_SPEED=10
  FIGHTER_SPAWN_DELAY=0
  FIGHTER_MAX_SPAWN_DELAY=100
  FIGHTER_LASERS=()
  MAX_FIGHTER_LASERS=$((MAX_FIGHTERS * 2))
  ((LEVEL++))
  ALIEN_FIRE_RATE=$((200 / LEVEL))
  create-starfield
}

game-mode() {
  export KEY=
  blank-screen

  reset-timers
  reset-game
  MUSIC_TRACK=$(((RANDOM % 3) + 1))
  music "level${MUSIC_TRACK}"
  GAME_MUSIC_THREAD=$!
  export LOOP=game-loop
}

object-collides-player() {
  local OBJECT_X=${1}
  local OBJECT_Y=${2}
  if ((OBJECT_X >= P1_X && OBJECT_X <= P1_X + P1_WIDTH )); then
    if ((OBJECT_Y >= P1_Y && OBJECT_Y <= P1_Y + P1_HEIGHT)); then
      return 0
    fi
  fi
  return 1
}

fighter-lasers() {
  local TOTAL_FIGHTER_LASERS=${#FIGHTER_LASERS[@]}
  local FIGHTER_LASER_INSTANCE=()
  local FIGHTER_LASER_X=0
  local FIGHTER_LASER_Y=0
  local FIGHTER_LASER_LOOP=0
  for (( FIGHTER_LASER_LOOP=0; FIGHTER_LASER_LOOP < TOTAL_FIGHTER_LASERS; FIGHTER_LASER_LOOP++ )); do
    FIGHTER_LASER_INSTANCE=(${FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]})
    FIGHTER_LASER_X=${FIGHTER_LASER_INSTANCE[0]}
    FIGHTER_LASER_Y=${FIGHTER_LASER_INSTANCE[1]}

    if ((FIGHTER_LASER_Y >= SCREEN_HEIGHT)); then
      erase-sprite 0 "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${FIGHTER_LASER_SPRITE[@]}"
      unset FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]
      FIGHTER_LASERS=("${FIGHTER_LASERS[@]}")
      ((TOTAL_FIGHTER_LASERS--))
      continue
    elif object-collides-player "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}"; then
      # Remove laser
      erase-sprite 0 "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${FIGHTER_LASER_SPRITE[@]}"
      unset FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]
      FIGHTER_LASERS=("${FIGHTER_LASERS[@]}")
      ((TOTAL_FIGHTER_LASERS--))

      # Player consequences
      sound player-explosion
      ((P1_LIVES--))
      continue
    else
      ((FIGHTER_LASER_Y++))
      FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]="${FIGHTER_LASER_X} ${FIGHTER_LASER_Y}"
    fi
    draw-sprite 0 "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${FIGHTER_LASER_SPRITE[@]}"
  done
}

fighter-ai() {
  local TOTAL_FIGHTERS=${#FIGHTERS[@]}
  local FIGHTER_LASER_COUNT=${#FIGHTER_LASERS[@]}
  local FIGHTER_INSTANCE=()
  local FIGHTER_X=0
  local FIGHTER_Y=0
  local FIGHTER_LOOP=0

  # Is it time to spawn a new alien fighter?
  if ((TOTAL_FIGHTERS < MAX_FIGHTERS)); then
    if ((RANDOM % ALIEN_SPAWN_RATE == 0)); then
      FIGHTER_X=$((RANDOM % FIGHTER_MAX_X))
      FIGHTERS+=("${FIGHTER_X} ${FIGHTER_Y}")
      ((TOTAL_FIGHTERS++))
    fi
  fi

  for (( FIGHTER_LOOP=0; FIGHTER_LOOP < TOTAL_FIGHTERS; FIGHTER_LOOP++ )); do
    FIGHTER_INSTANCE=(${FIGHTERS[${FIGHTER_LOOP}]})
    FIGHTER_X=${FIGHTER_INSTANCE[0]}
    FIGHTER_Y=${FIGHTER_INSTANCE[1]}

    if ((FIGHTER_ANIM_SPEED == 0)); then
      if ((FIGHTER_Y > FIGHTER_FLOOR)); then
        # Remove the fighter
        erase-sprite 1 "${FIGHTER_X}" "${FIGHTER_Y}" "${FIGHTER_SPRITE[@]}"
        unset FIGHTERS[${FIGHTER_LOOP}]
        FIGHTERS=("${FIGHTERS[@]}")
        ((TOTAL_FIGHTERS--))
        continue
      elif object-collides-player "$((FIGHTER_X + 3))" "$((FIGHTER_Y + 4))"; then
        # Remove the fighter
        erase-sprite 1 "${FIGHTER_X}" "${FIGHTER_Y}" "${FIGHTER_SPRITE[@]}"
        unset FIGHTERS[${FIGHTER_LOOP}]
        FIGHTERS=("${FIGHTERS[@]}")
        ((TOTAL_FIGHTERS--))

        # Player consequences
        sound player-explosion
        ((P1_LIVES--))
        ((P1_SCORE++))
        ((P1_KILLS++))

        continue
      else
        ((FIGHTER_Y++))
        FIGHTERS[${FIGHTER_LOOP}]="${FIGHTER_X} ${FIGHTER_Y}"
      fi
    fi

    # Should the fighter unleash a laser?
    if ((FIGHTER_LASER_COUNT < MAX_FIGHTER_LASERS && FIGHTER_Y <= (P1_Y - P1_HEIGHT) )); then
      if ((RANDOM % ALIEN_FIRE_RATE == 0)); then
        sound fighter-laser
        FIGHTER_LASERS+=("$((FIGHTER_X + 3)) $((FIGHTER_Y + 4))")
        ((FIGHTER_LASER_COUNT++))
      fi
    fi
    draw-sprite 1 "${FIGHTER_X}" "${FIGHTER_Y}" "${FIGHTER_SPRITE[@]}"
  done

  # Increment the fighter movement
  [[ ${FIGHTER_ANIM_SPEED} -ge ${FIGHTER_CURRENT_SPEED} ]] && FIGHTER_ANIM_SPEED=0 || ((FIGHTER_ANIM_SPEED++))

  # Increant the fighter spawn delay
  [[ ${FIGHTER_SPAWN_DELAY} -ge ${FIGHTER_MAX_SPAWN_DELAY} ]] && FIGHTER_SPAWN_DELAY=0 || ((FIGHTER_SPAWN_DELAY++))
}

player-laser-hit-fighter() {
  local LASER_X=${1}
  local LASER_Y=${2}
  local TOTAL_FIGHTERS=${#FIGHTERS[@]}
  local FIGHTER_INSTANCE=()
  local FIGHTER_X=0
  local FIGHTER_Y=0
  local FIGHTER_LOOP=0
  for (( FIGHTER_LOOP=0; FIGHTER_LOOP < TOTAL_FIGHTERS; FIGHTER_LOOP++ )); do
    FIGHTER_INSTANCE=(${FIGHTERS[${FIGHTER_LOOP}]})
    FIGHTER_X=${FIGHTER_INSTANCE[0]}
    FIGHTER_Y=${FIGHTER_INSTANCE[1]}
    if ((LASER_X >= FIGHTER_X && LASER_X <= FIGHTER_X + FIGHTER_WIDTH)); then
      if ((LASER_Y >= FIGHTER_Y && LASER_Y <= FIGHTER_Y + FIGHTER_HEIGHT)); then
        # Remove the fighter
        sound fighter-explosion
        erase-sprite 1 "${FIGHTER_X}" "${FIGHTER_Y}" "${FIGHTER_SPRITE[@]}"
        unset FIGHTERS[${FIGHTER_LOOP}]
        FIGHTERS=("${FIGHTERS[@]}")
        ((TOTAL_FIGHTERS--))
        return 0
      fi
    fi
  done
  return 1
}

player-lasers() {
  local TOTAL_P1_LASERS=${#P1_LASERS[@]}
  local LASER_INSTANCE=()
  local LASER_X=0
  local LASER_Y=0
  local LASER_LOOP=0
  for (( LASER_LOOP=0; LASER_LOOP < TOTAL_P1_LASERS; LASER_LOOP++ )); do
    LASER_INSTANCE=(${P1_LASERS[${LASER_LOOP}]})
    LASER_X=${LASER_INSTANCE[0]}
    LASER_Y=${LASER_INSTANCE[1]}
    if ((LASER_Y <= P1_LASER_CEILING)); then
      erase-sprite 0 "${LASER_X}" "${LASER_Y}" "${P1_LASER_SPRITE[@]}"
      unset P1_LASERS[${LASER_LOOP}]
      P1_LASERS=("${P1_LASERS[@]}")
      ((TOTAL_P1_LASERS--))
      continue
    elif player-laser-hit-fighter "${LASER_X}" "${LASER_Y}"; then
      erase-sprite 0 "${LASER_X}" "${LASER_Y}" "${P1_LASER_SPRITE[@]}"
      unset P1_LASERS[${LASER_LOOP}]
      P1_LASERS=("${P1_LASERS[@]}")
      ((P1_SCORE++))
      ((P1_KILLS++))
      ((TOTAL_P1_LASERS--))
      continue
    else
      ((LASER_Y--))
      P1_LASERS[$LASER_LOOP]="${LASER_X} ${LASER_Y}"
    fi
    draw-sprite 0 "${LASER_X}" "${LASER_Y}" "${P1_LASER_SPRITE[@]}"
  done
}

game-loop() {
  # Movement
  case ${KEY} in
    'w')
      ((P1_Y--))
      # Prevent leaving the top of the screen
      ((P1_Y < 1)) && P1_Y=1
      P1_LAST_KEY=${KEY}
      ;;
    's')
      ((P1_Y++))
      # Prevent leaving the bottom of the screen
      ((P1_Y > P1_MAX_Y)) && P1_Y=${P1_MAX_Y}
      P1_LAST_KEY=${KEY}
      ;;
    'a')
      ((P1_X--))
      # Prevent leaving screen left
      ((P1_X < 0)) && P1_X=0
      P1_LAST_KEY=${KEY}
      ;;
    'd')
      ((P1_X++))
      # Prevent leaving screne right
      ((P1_X > P1_MAX_X)) && P1_X=${P1_MAX_X}
      P1_LAST_KEY=${KEY}
      ;;
    'l')
      if ((P1_RECENTLY_FIRED == 0 )); then
        sound player-laser
        P1_LASERS+=("$((P1_X + 4)) $((P1_Y - 1))")
        ((P1_RECENTLY_FIRED+=P1_LASER_LATENCY))
      fi
      P1_LAST_KEY=${KEY}
      ;;
  esac
  KEY=

  # Regulate Player 1 laser fire frequency
  if [ "${P1_LAST_KEY}" != 'l' ]; then
    P1_RECENTLY_FIRED=0
  elif ((P1_RECENTLY_FIRED > 0)); then
    ((P1_RECENTLY_FIRED--))
  fi

  # Victory condition stub
  if ((P1_KILLS >= 10)); then
      kill-thread ${GAME_MUSIC_THREAD}
      victory-mode
      return 1
  fi

  # Game over condition stub
  if ((P1_LIVES <= 0)); then
    kill-thread ${GAME_MUSIC_THREAD}
    gameover-mode
    return 1
  fi

  compose-sprites
  animate-starfield
  draw-sprite 1 "${P1_X}" "${P1_Y}" "${P1_SPRITE[@]}"
  fighter-ai
  fighter-lasers
  player-lasers

  draw 0 0 "${STATUS_COLOR}" "Lives: ${P1_LIVES}"
  draw-right 0 "${STATUS_COLOR}" "Score: ${P1_SCORE}"
  render
}
