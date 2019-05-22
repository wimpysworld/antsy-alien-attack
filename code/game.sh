#!/usr/bin/env bash

level-up() {
  ((LEVEL++))
  ((LEVEL_UP_KILLS++))
  ((MAX_FIGHTERS++))
  ((FIGHTER_CURRENT_SPEED--))
  export P1_KILLS=0
  export P2_KILLS=0

  # Fighters have increased fire power as the levels progress.
  export MAX_FIGHTER_LASERS=$((MAX_FIGHTERS * 2))
  # The rgion where smart fighter originate enlarges as levels progress.
  export FIGHTER_SMART_REGION=$((SCREEN_WIDTH / (LAST_LEVEL + 2 + LEVEL) ))
  # More points for fighters as the levels progress.
  export FIGHTER_POINTS=$((LEVEL * 10))

  # Alien spawn rate and fire rate increase with level progression
  export ALIEN_FIRE_RATE=$((200 / LEVEL))
  export ALIEN_SPAWN_RATE=$((125 / LEVEL))

  # Rate at which enemy kills yeild bonuses
  export BONUS_SPAWN_RATE=$((LEVEL * 2))
  sound level ${LEVEL}
}

reset-game() {
  export LEVEL=0
  export LEVEL_UP_KILLS=4
  export LAST_LEVEL=5
  export HI_SCORE=0
  readonly P1=1
  readonly P2=2
  export P1_SCORE=0
  export P2_SCORE=0
  export P1_LIVES=3
  export P2_LIVES=3
  export P1_X=$(( (SCREEN_WIDTH - P1_WIDTH) / 2 ))
  export P1_Y=$(( SCREEN_HEIGHT - P1_HEIGHT ))
  export P2_X=0
  export P2_Y=0
  export P1_MAX_X=$(( SCREEN_WIDTH  - (P1_WIDTH + 2) ))
  export P1_MAX_Y=$(( SCREEN_HEIGHT - P1_HEIGHT ))
  export P2_MAX_X=$(( SCREEN_WIDTH  - (P2_WIDTH + 2) ))
  export P2_MAX_Y=$(( SCREEN_HEIGHT - P2_HEIGHT ))
  export P1_LASERS=()
  export P2_LASERS=()
  export P1_LASER_CEILING=0
  export P2_LASER_CEILING=0
  export P1_RECENTLY_FIRED=0
  export P2_RECENTLY_FIRED=0
  export P1_LASER_LATENCY=6
  export P2_LASER_LATENCY=6
  export P1_LAST_KEY=
  export P2_LAST_KEY=
  export FIGHTERS=()
  export MAX_FIGHTERS=0
  export FIGHTER_MAX_X=$(( SCREEN_WIDTH  - (FIGHTER_WIDTH + 2) ))
  export FIGHTER_MAX_Y=$(( SCREEN_HEIGHT - FIGHTER_HEIGHT ))
  export FIGHTER_ANIM_SPEED=0
  export FIGHTER_CURRENT_SPEED=11
  export FIGHTER_LASERS=()
  readonly FIGHTER_FLOOR=$((SCREEN_HEIGHT + FIGHTER_HEIGHT))
  export BONUSES=()
  create-starfield
  level-up
}

game-mode() {
  export KEY=
  export PLAYER_STATS_REFRESH=0
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

spawn-bonus() {
  if ((RANDOM % BONUS_SPAWN_RATE == 0)); then
    local BONUS_X="${1}"
    local BONUS_Y="${2}"
    BONUSES+=("${BONUS_X} ${BONUS_Y}")
  fi
}

bonuses() {
  local TOTAL_BONUSES=${#BONUSES[@]}
  local BONUS_INSTANCE=()
  local BONUS_X=0
  local BONUS_Y=0
  local BONUS_LOOP=0
  for (( BONUS_LOOP=0; BONUS_LOOP < TOTAL_BONUSES; BONUS_LOOP++ )); do
    BONUS_INSTANCE=(${BONUSES[${BONUS_LOOP}]})
    BONUS_X=${BONUS_INSTANCE[0]}
    BONUS_Y=${BONUS_INSTANCE[1]}

    # Bonuses move off screen at the same pace as fighters.
    if ((FIGHTER_ANIM_SPEED == 0)); then    
      if ((BONUS_Y >= SCREEN_HEIGHT)); then
        erase-sprite 0 "${BONUS_X}" "${BONUS_Y}" "${BONUS_SPRITE[@]}"
        unset BONUSES[${BONUS_LOOP}]
        BONUSES=("${BONUSES[@]}")
        ((TOTAL_BONUSES--))
        continue
      elif object-collides-player "${BONUS_X}" "${BONUS_Y}"; then
        # Remove laser
        erase-sprite 0 "${BONUS_X}" "${BONUS_Y}" "${BONUS_SPRITE[@]}"
        unset BONUSES[${BONUS_LOOP}]
        BONUSES=("${BONUSES[@]}")
        ((TOTAL_BONUSES--))

        # Player consequences
        sound bonus-points
        ((P1_SCORE+=1000))
        continue
      else
        ((BONUS_Y++))
        BONUSES[${BONUS_LOOP}]="${BONUS_X} ${BONUS_Y}"
      fi
      draw-sprite 0 "${BONUS_X}" "${BONUS_Y}" "${BONUS_SPRITE[@]}"
    fi
  done
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
  local FIGHTER_SMART=0
  local FIGHTER_LOOP=0

  # Is it time to spawn a new alien fighter?
  if ((TOTAL_FIGHTERS < MAX_FIGHTERS)); then
    if ((RANDOM % ALIEN_SPAWN_RATE == 0)); then
      FIGHTER_X=$((RANDOM % FIGHTER_MAX_X))

      # Does this fighter have smarts?
      if ((FIGHTER_X <= FIGHTER_SMART_REGION)) || ((FIGHTER_X >= (SCREEN_WIDTH - FIGHTER_SMART_REGION) )); then
        FIGHTER_SMART=1
      else
        FIGHTER_SMART=0
      fi
      FIGHTERS+=("${FIGHTER_X} ${FIGHTER_Y} ${FIGHTER_SMART}")
      ((TOTAL_FIGHTERS++))
    fi
  fi

  for (( FIGHTER_LOOP=0; FIGHTER_LOOP < TOTAL_FIGHTERS; FIGHTER_LOOP++ )); do
    FIGHTER_INSTANCE=(${FIGHTERS[${FIGHTER_LOOP}]})
    FIGHTER_X=${FIGHTER_INSTANCE[0]}
    FIGHTER_Y=${FIGHTER_INSTANCE[1]}
    FIGHTER_SMART=${FIGHTER_INSTANCE[2]}

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
        ((P1_SCORE+=FIGHTER_POINTS))
        ((P1_KILLS++))

        continue
      else
        ((FIGHTER_Y++))

        # Hunt the player.
        if ((FIGHTER_SMART == 1)); then
          if ((FIGHTER_X <= P1_X)); then
            ((FIGHTER_X++))
          elif ((FIGHTER_X >= P1_X)); then
            ((FIGHTER_X--))
          fi
        else
          # OK dummy, time to make a random lateral movement?
          case $((RANDOM % 5)) in
            0) ((FIGHTER_X--));;
            4) ((FIGHTER_X++));;
          esac
        fi

        # Prevent leaving screen left
        ((FIGHTER_X < 0)) && FIGHTER_X=0
        # Prevent leaving screen right
        ((FIGHTER_X > FIGHTER_MAX_X)) && FIGHTER_X=${FIGHTER_MAX_X}

        FIGHTERS[${FIGHTER_LOOP}]="${FIGHTER_X} ${FIGHTER_Y} ${FIGHTER_SMART}"
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
        spawn-bonus "${FIGHTER_X}" "${FIGHTER_Y}"
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
      ((P1_SCORE+=FIGHTER_POINTS))
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

  # Level up
  if ((P1_KILLS + P2_KILLS >= LEVEL_UP_KILLS)); then
    level-up
  fi

  # Victory condition stub
  if ((LEVEL > LAST_LEVEL)); then
      kill-thread ${GAME_MUSIC_THREAD}
      victory-mode
      return 1
  fi

  # Game over condition stub
  if ((P1_LIVES + P2_LIVES <= 0)); then
    kill-thread ${GAME_MUSIC_THREAD}
    gameover-mode
    return 1
  fi

  # These are quite expensive, only refresh them periodically
  if ((PLAYER_STATS_REFRESH == 0)); then
    if ((P1_SCORE > HI_SCORE)); then
      HI_SCORE=${P1_SCORE}
    elif ((P2_SCORE > HI_SCORE)); then
      HI_SCORE=${P2_SCORE}
    fi
    P1_SCORE_PADDED=$(printf "%06d" ${P1_SCORE})
    P2_SCORE_PADDED=$(printf "%06d" ${P2_SCORE})
    HI_SCORE_PADDED=$(printf "%06d" ${HI_SCORE})
    P1_LIVES_SYMBOLS=$(repeat "♥" "${P1_LIVES}")" "
    P2_LIVES_SYMBOLS=" "$(repeat "♥" "${P2_LIVES}")
  fi

  compose-sprites
  animate-starfield
  draw-sprite 1 "${P1_X}" "${P1_Y}" "${P1_SPRITE[@]}"
  fighter-ai
  fighter-lasers
  player-lasers
  bonuses

  draw 0 0 "${RED}${BBLK}" "1UP ${P1_SCORE_PADDED}"
  draw-centered 0 "${WHT}${BBLK}" "HISCORE ${HI_SCORE_PADDED}"
  draw-right 0 "${blu}${BBLK}" "${P2_SCORE_PADDED} 2UP"
  draw 0 "${SCREEN_HEIGHT}" "${RED}${BBLK}" "LIVES ${P1_LIVES_SYMBOLS}"
  draw-right "${SCREEN_HEIGHT}" "${blu}${BBLK}" "${P2_LIVES_SYMBOLS} LIVES"
  render

  # Increment the player stats refresh interval
  ((PLAYER_STATS_REFRESH > 100)) && PLAYER_STATS_REFRESH=0 || ((PLAYER_STATS_REFRESH++))
}
