#!/usr/bin/env bash

round-up() {
  kill-thread ${GAME_MUSIC_THREAD}
  local LOOP=0
  local TEMP_BONUS=0
  local TEMP_BONUS_PADDED=0
  local Y_CENTER=$((SCREEN_HEIGHT / 2 ))
  TEMP_BONUS_PADDED=$(printf "%07d" ${TEMP_BONUS})

  sound round ${LEVEL} objective-achieved
  draw-picture-centered level-${LEVEL}
  lol-draw-centered $((Y_CENTER - 2)) "SKILL BONUS"
  lol-draw-centered $((Y_CENTER - 1)) "-----------"
  if ((P1_DEAD ==0)); then
    lol-draw-centered $((Y_CENTER + 0)) "PLAYER 1 KILL BONUS : ${TEMP_BONUS_PADDED}"
    lol-draw-centered $((Y_CENTER + 2)) "PLAYER 1 LIFE BONUS : ${TEMP_BONUS_PADDED}"
  fi
  if ((P2_DEAD ==0)); then
    lol-draw-centered $((Y_CENTER + 4)) "PLAYER 2 KILL BONUS : ${TEMP_BONUS_PADDED}"
    lol-draw-centered $((Y_CENTER + 6)) "PLAYER 2 LIFE BONUS : ${TEMP_BONUS_PADDED}"
  fi
  render
  sleep 0.5

  if ((P1_DEAD == 0)); then
    P1_SHIELDS=150
    TEMP_BONUS=0
    for (( LOOP=0; LOOP < P1_KILLS; LOOP++ )); do
      sound zap
      ((TEMP_BONUS+=FIGHTER_POINTS))
      TEMP_BONUS_PADDED=$(printf "%07d" ${TEMP_BONUS})
      lol-draw-centered $((Y_CENTER + 0)) "PLAYER 1 KILL BONUS : ${TEMP_BONUS_PADDED}"
      render
      sleep 0.1
    done
    ((P1_SCORE+=TEMP_BONUS))

    TEMP_BONUS=0
    for (( LOOP=0; LOOP < P1_LIVES; LOOP++ )); do
      sound zap
      ((TEMP_BONUS+=BONUS_POINTS))
      TEMP_BONUS_PADDED=$(printf "%07d" ${TEMP_BONUS})
      lol-draw-centered $((Y_CENTER + 2)) "PLAYER 1 LIFE BONUS : ${TEMP_BONUS_PADDED}"
      render
      sleep 0.1
    done
    ((P1_SCORE+=TEMP_BONUS))
  fi

  if ((P2_DEAD == 0)); then
    P2_SHIELDS=150
    TEMP_BONUS=0
    for (( LOOP=0; LOOP < P2_KILLS; LOOP++ )); do
      sound zap
      ((TEMP_BONUS+=FIGHTER_POINTS))
      TEMP_BONUS_PADDED=$(printf "%07d" ${TEMP_BONUS})
      lol-draw-centered $((Y_CENTER + 4)) "PLAYER 2 KILL BONUS : ${TEMP_BONUS_PADDED}"
      render
      sleep 0.1
    done
    ((P2_SCORE+=TEMP_BONUS))

    TEMP_BONUS=0
    for (( LOOP=0; LOOP < P2_LIVES; LOOP++ )); do
      sound zap
      ((TEMP_BONUS+=BONUS_POINTS))
      TEMP_BONUS_PADDED=$(printf "%07d" ${TEMP_BONUS})
      lol-draw-centered $((Y_CENTER + 6)) "PLAYER 2 LIFE BONUS : ${TEMP_BONUS_PADDED}"
      render
      sleep 0.1
    done
    ((P2_SCORE+=TEMP_BONUS))
  fi
  sleep 3
  blank-screen
}

level-up() {
  # Remove all fighters and lasers.
  export FIGHTERS=()
  export FIGHTER_LASERS=()

  MUSIC_TRACK=$(((RANDOM % 3) + 1))
  music "level${MUSIC_TRACK}"
  GAME_MUSIC_THREAD=$!

  ((LEVEL++))
  export MAX_FIGHTERS=$((LEVEL + 1))
  case ${LEVEL} in
    1) export LEVEL_COMPENSATION=6
       export MAX_FIGHTER_LASERS=$((MAX_FIGHTERS + 3))
       ;;
    2) export LEVEL_COMPENSATION=6
       export MAX_FIGHTER_LASERS=$((MAX_FIGHTERS + 2))
       ;;
    3) export LEVEL_COMPENSATION=5
       export MAX_FIGHTER_LASERS=$((MAX_FIGHTERS + 2))
       ;;
    4) export LEVEL_COMPENSATION=5
       export MAX_FIGHTER_LASERS=$((MAX_FIGHTERS + 1))
       ;;
    5) export LEVEL_COMPENSATION=4
       export MAX_FIGHTER_LASERS=${MAX_FIGHTERS}
       ;;
    *) export LEVEL_COMPENSATION=3
       export MAX_FIGHTER_LASERS=${MAX_FIGHTERS}
       ;;
  esac
  # Number of fighters that need to be vaniquished to level-up
  export LEVEL_UP_KILLS=$((5 + (LEVEL * (MAX_FIGHTERS * 5)) ))
  export P1_KILLS=0
  export P2_KILLS=0

  # More points for fighters as the levels progress.
  export FIGHTER_POINTS=$((LEVEL * 10))

  # Alien spawn rate and fire rate increase with level progression
  export ALIEN_FIRE_RATE=$((200 / LEVEL))
  export ALIEN_SPAWN_RATE=$((125 / LEVEL))

  # Rate at which enemy kills yeild bonuses
  export BONUS_SPAWN_RATE=$((LEVEL * 2))
  export BONUS_POINTS=$((1000 * LEVEL))
  export BONUS_COLLECT=$((100 * LEVEL))
  export FIGHTERS_SPAWNED=0
  export FIGHTERS_ESCAPED=0

  # Announce the level
  if ((LEVEL == 1)); then
    sound ready level ${LEVEL} go
  elif ((LEVEL == LAST_LEVEL)); then
    sound level ${LEVEL} final_round
  elif ((LEVEL <= LAST_LEVEL)); then
    sound level ${LEVEL}
  fi
}

reset-game() {
  export LEVEL=0
  export LAST_LEVEL=5
  readonly P1=1
  readonly P2=2
  export P1_SCORE=0
  export P2_SCORE=0
  export P1_HI_SCORE_BEATEN=0
  export P2_HI_SCORE_BEATEN=0
  case ${NUM_PLAYERS} in
    1)
      export P1_DEAD=0
      export P1_LIVES=3
      export P1_STARTX=$(( (SCREEN_WIDTH - P1_WIDTH) / 2 ))
      export P1_STARTY=$(( SCREEN_HEIGHT - (P1_HEIGHT * 2) ))
      export P2_DEAD=1
      export P2_LIVES=0
      export P2_STARTX=0
      export P2_STARTY=0
      ;;
    2)
      export P1_DEAD=0
      export P1_LIVES=3
      export P1_STARTX=$(( (SCREEN_WIDTH / 2) - (P1_WIDTH * 4) ))
      export P1_STARTY=$(( SCREEN_HEIGHT - (P1_HEIGHT * 2) ))
      export P2_DEAD=0
      export P2_LIVES=3
      export P2_STARTX=$(( (SCREEN_WIDTH / 2) + (P2_WIDTH * 3) ))
      export P2_STARTY=$(( SCREEN_HEIGHT - (P2_HEIGHT * 2) ))
      ;;
  esac
  export P1_X=${P1_STARTX}
  export P1_Y=${P1_STARTY}
  export P2_X=${P2_STARTX}
  export P2_Y=${P2_STARTY}
  export P1_MAX_X=$(( SCREEN_WIDTH  - (P1_WIDTH  + 1) ))
  export P1_MAX_Y=$(( SCREEN_HEIGHT - (P1_HEIGHT - 1) ))
  export P2_MAX_X=$(( SCREEN_WIDTH  - (P2_WIDTH  + 1) ))
  export P2_MAX_Y=$(( SCREEN_HEIGHT - (P2_HEIGHT - 1) ))
  export P1_LASERS=()
  export P2_LASERS=()
  export P1_FIRE_POWER=1
  export P2_FIRE_POWER=1
  export P1_LASER_CEILING=2
  export P2_LASER_CEILING=2
  export P1_RECENTLY_FIRED=0
  export P2_RECENTLY_FIRED=0
  export P1_LASER_LATENCY=20
  export P2_LASER_LATENCY=20
  export P1_LAST_KEY=
  export P2_LAST_KEY=
  export P1_SHIELDS=0
  export P2_SHIELDS=0
  export P1_RESPAWN=0
  export P2_RESPAWN=0
  export P1_FRAME=0
  export P2_FRAME=0
  export FIGHTERS=()
  export FIGHTER_MAX_X=$((SCREEN_WIDTH  - FIGHTER_WIDTH  + 1))
  export FIGHTER_MAX_Y=$((SCREEN_HEIGHT - FIGHTER_HEIGHT - 2))
  export FIGHTER_AIMING_FLOOR=$((SCREEN_HEIGHT - (FIGHTER_HEIGHT * 2) ))
  export FIGHTER_LASERS=()
  # Fighter types
  readonly SNIPER=1
  readonly HUNTER=2
  # The region where hunters originate
  readonly HUNT_REGION_LEFT=$(( (SCREEN_WIDTH / 2) - (FIGHTER_WIDTH * 6) ))
  readonly HUNT_REGION_RIGHT=$(( (SCREEN_WIDTH / 2) + (FIGHTER_WIDTH * 6) ))
  export BONUSES=()
  create-starfield
  level-up
}

game-mode() {
  readonly NUM_PLAYERS=${1}
  export DELAY=0.005
  export KEY=
  blank-screen

  reset-timers
  reset-game
  reset-gfx-timers
  export LOOP=game-loop
}

object-collides-player() {
  local PLAYER=${1}
  local OBJECT_X=${2}
  local OBJECT_Y=${3}

  if ((PLAYER == 1 && P1_DEAD == 0 && P1_FRAME == 0)); then
    if ((OBJECT_X >= P1_X && OBJECT_X <= P1_X + P1_WIDTH )); then
      if ((OBJECT_Y >= P1_Y && OBJECT_Y <= P1_Y + P1_HEIGHT)); then
        return 0
      fi
    fi
    return 1
  elif ((PLAYER == 2 && P2_DEAD == 0 && P2_FRAME == 0)); then
    if ((OBJECT_X >= P2_X && OBJECT_X <= P2_X + P2_WIDTH )); then
      if ((OBJECT_Y >= P2_Y && OBJECT_Y <= P2_Y + P2_HEIGHT)); then
        return 0
      fi
    fi
    return 1
  else
    return 1
  fi
}

player-increment-score() {
  local PLAYER=${1}
  local INCREMENT=${2}
  case ${PLAYER} in
    1) ((P1_SCORE+=INCREMENT));;
    2) ((P2_SCORE+=INCREMENT));;
  esac
}

player-respawn() {
  local PLAYER=${1}
  case ${PLAYER} in
    1) P1_FRAME=0
       P1_SHIELDS=150
       P1_RESPAWN=1
       P1_X=${P1_STARTX}
       P1_Y=${P1_STARTY}
       ;;
    2) P2_FRAME=0
       P2_SHIELDS=150
       P2_RESPAWN=1
       P2_X=${P2_STARTX}
       P2_Y=${P2_STARTY}
       ;;
  esac
}

player-death() {
  local PLAYER=${1}
  case ${PLAYER} in
    1) sound-explosion
       erase-sprite-masked "${P1_X}" "${P1_Y}" "${P1_SPRITE[@]}"
       ((P1_LIVES--))
       P1_FRAME=1
       P1_FIRE_POWER=1
       ;;
    2) sound-explosion
       erase-sprite-masked "${P2_X}" "${P2_Y}" "${P2_SPRITE[@]}"
       ((P2_LIVES--))
       P2_FRAME=1
       P2_FIRE_POWER=1
       ;;
  esac
}

player-sprite() {
  local PLAYER=${1}
  case ${PLAYER} in
    1) case ${P1_FRAME} in
         0) draw-sprite-masked "${P1_X}" "${P1_Y}" "${P1_SPRITE[@]}";;
         1) draw-sprite-masked "${P1_X}" "${P1_Y}" "${P1_EXPLODE1[@]}";;
         2) draw-sprite-masked "${P1_X}" "${P1_Y}" "${P1_EXPLODE2[@]}";;
         3) draw-sprite-masked "${P1_X}" "${P1_Y}" "${P1_EXPLODE3[@]}";;
         4) draw-sprite-masked "${P1_X}" "${P1_Y}" "${P1_EXPLODE4[@]}";;
         5) draw-sprite-masked "${P1_X}" "${P1_Y}" "${P1_EXPLODE5[@]}";;
         6) erase-sprite-masked "${P1_X}" "${P1_Y}" "${P1_EXPLODE5[@]}"
            player-respawn ${P1}
            ;;
       esac
       ;;
    2) case ${P2_FRAME} in
         0) draw-sprite-masked "${P2_X}" "${P2_Y}" "${P2_SPRITE[@]}";;
         1) draw-sprite-masked "${P2_X}" "${P2_Y}" "${P2_EXPLODE1[@]}";;
         2) draw-sprite-masked "${P2_X}" "${P2_Y}" "${P2_EXPLODE2[@]}";;
         3) draw-sprite-masked "${P2_X}" "${P2_Y}" "${P2_EXPLODE3[@]}";;
         4) draw-sprite-masked "${P2_X}" "${P2_Y}" "${P2_EXPLODE4[@]}";;
         5) draw-sprite-masked "${P2_X}" "${P2_Y}" "${P2_EXPLODE5[@]}";;
         6) erase-sprite-masked "${P2_X}" "${P2_Y}" "${P2_EXPLODE5[@]}"
            player-respawn ${P2}
            ;;
       esac
       ;;
  esac
}

deploy-smartbomb() {
  local PLAYER=${1}
  local FIGHTER_INSTANCE=()
  local FIGHTER_X=0
  local FIGHTER_Y=0
  local FIGHTER_TYPE=0
  local FIGHTER_FRAME=0
  local FIGHTER_LOOP=0

  for FIGHTER_LOOP in "${!FIGHTERS[@]}"; do
    FIGHTER_INSTANCE=(${FIGHTERS[${FIGHTER_LOOP}]})
    FIGHTER_X=${FIGHTER_INSTANCE[0]}
    FIGHTER_Y=${FIGHTER_INSTANCE[1]}
    FIGHTER_TYPE=${FIGHTER_INSTANCE[2]}
    FIGHTER_FRAME=${FIGHTER_INSTANCE[3]}
    if ((FIGHTER_FRAME == 0)); then
      case ${FIGHTER_TYPE} in
        $HUNTER) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${HUNTER_SPRITE[@]}";;
        $SNIPER) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${SNIPER_SPRITE[@]}";;
      esac
      FIGHTER_FRAME=1
      FIGHTERS[${FIGHTER_LOOP}]="${FIGHTER_X} ${FIGHTER_Y} ${FIGHTER_TYPE} ${FIGHTER_FRAME}"
      sound-explosion
      spawn-bonus "${FIGHTER_X}" "${FIGHTER_Y}"
      player-increment-score ${PLAYER} ${FIGHTER_POINTS}
    fi
  done
}

activate-bonus() {
  local PLAYER=${1}
  local BONUS_TYPE=${2}

  case ${BONUS_TYPE} in
    0) player-increment-score ${PLAYER} ${BONUS_POINTS}
       sound bonus-points
       ;;
    1) player-increment-score ${PLAYER} ${BONUS_COLLECT}
       sound extra-life
       case ${PLAYER} in
         1) ((P1_LIVES++));;
         2) ((P2_LIVES++));;
       esac
       ;;
    2) player-increment-score ${PLAYER} ${BONUS_COLLECT}
       sound smart-bomb
       deploy-smartbomb ${PLAYER}
       ;;
    3) player-increment-score ${PLAYER} ${BONUS_COLLECT}
       sound shield-up
       case ${PLAYER} in
         1) ((P1_SHIELDS+=1000));;
         2) ((P2_SHIELDS+=1000));;
       esac
       ;;
    4) player-increment-score ${PLAYER} ${BONUS_COLLECT}
       case ${PLAYER} in
         1) if ((P1_FIRE_POWER < 2)); then
              ((P1_FIRE_POWER+=1))
              sound power-up
            else 
              sound bonus-points
            fi
            ;;
         2) if ((P2_FIRE_POWER < 2)); then
              ((P2_FIRE_POWER+=1))
              sound power-up
            else 
              sound bonus-points
            fi
            ;;
       esac
       ;;
  esac
}

spawn-bonus() {
  if ((RANDOM % BONUS_SPAWN_RATE == 0)); then
    local BONUS_X="${1}"
    local BONUS_Y="${2}"
    local BONUS_TYPE=$((RANDOM % 5))
    ((BONUS_X+=2))
    BONUSES+=("${BONUS_X} ${BONUS_Y} ${BONUS_TYPE}")
  fi
}

bonuses() {
  # Bonuses move off screen at the same pace as fighters.
  if ((ANIMATION_KEYFRAME % 10 == 0)); then
    local TOTAL_BONUSES=${#BONUSES[@]}
    local BONUS_INSTANCE=()
    local BONUS_X=0
    local BONUS_Y=0
    local BONUS_TYPE=0
    local BONUS_LOOP=0
    local BONUS_SPRITE=()
    for (( BONUS_LOOP=0; BONUS_LOOP < TOTAL_BONUSES; BONUS_LOOP++ )); do
      BONUS_INSTANCE=(${BONUSES[${BONUS_LOOP}]})
      BONUS_X=${BONUS_INSTANCE[0]}
      BONUS_Y=${BONUS_INSTANCE[1]}
      BONUS_TYPE=${BONUS_INSTANCE[2]}
      case ${BONUS_TYPE} in
        0) BONUS_SPRITE=(
           "$SPC "
           "$ylw$"
           );;
        1) BONUS_SPRITE=(
           "$SPC "
           "$red♥"
           );;
        2) BONUS_SPRITE=(
           "$SPC "
           "$cyn☼"
           );;
        3) BONUS_SPRITE=(
           "$SPC "
           "$grn≡"
           );;
        4) BONUS_SPRITE=(
           "$SPC "
           "$mgn‼"
           );;
      esac
      if ((BONUS_Y >= SCREEN_HEIGHT)); then
        erase-sprite-unmasked "${BONUS_X}" "${BONUS_Y}" "${BONUS_SPRITE[@]}"
        unset BONUSES[${BONUS_LOOP}]
        BONUSES=("${BONUSES[@]}")
        ((TOTAL_BONUSES--))
        continue
      elif object-collides-player ${P1} "${BONUS_X}" "${BONUS_Y}"; then
        erase-sprite-unmasked "${BONUS_X}" "${BONUS_Y}" "${BONUS_SPRITE[@]}"
        unset BONUSES[${BONUS_LOOP}]
        BONUSES=("${BONUSES[@]}")
        ((TOTAL_BONUSES--))
        activate-bonus ${P1} ${BONUS_TYPE}
        continue
      elif object-collides-player ${P2} "${BONUS_X}" "${BONUS_Y}"; then
        erase-sprite-unmasked "${BONUS_X}" "${BONUS_Y}" "${BONUS_SPRITE[@]}"
        unset BONUSES[${BONUS_LOOP}]
        BONUSES=("${BONUSES[@]}")
        ((TOTAL_BONUSES--))
        activate-bonus ${P2} ${BONUS_TYPE}
        continue
      else
        ((BONUS_Y++))
        BONUSES[${BONUS_LOOP}]="${BONUS_X} ${BONUS_Y} ${BONUS_TYPE}"
        draw-sprite-unmasked "${BONUS_X}" "${BONUS_Y}" "${BONUS_SPRITE[@]}"
      fi
    done
  fi
}

fighter-lasers() {
  local TOTAL_FIGHTER_LASERS=${#FIGHTER_LASERS[@]}
  local FIGHTER_LASER_INSTANCE=()
  local FIGHTER_LASER_X=0
  local FIGHTER_LASER_Y=0
  local FIGHTER_LASER_TYPE=0
  local FIGHTER_LASER_TARGET_X=0
  local FIGHTER_LASER_TARGET_Y=0
  local FIGHTER_LASER_LOOP=0
  local DX=0
  local DY=0
  local ABSDX=0
  local ABSDY=0
  for (( FIGHTER_LASER_LOOP=0; FIGHTER_LASER_LOOP < TOTAL_FIGHTER_LASERS; FIGHTER_LASER_LOOP++ )); do
    FIGHTER_LASER_INSTANCE=(${FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]})
    FIGHTER_LASER_X=${FIGHTER_LASER_INSTANCE[0]}
    FIGHTER_LASER_Y=${FIGHTER_LASER_INSTANCE[1]}
    FIGHTER_LASER_TYPE=${FIGHTER_LASER_INSTANCE[2]}
    FIGHTER_LASER_TARGET_X=${FIGHTER_LASER_INSTANCE[3]}
    FIGHTER_LASER_TARGET_Y=${FIGHTER_LASER_INSTANCE[4]}

    case ${FIGHTER_LASER_TYPE} in
      $HUNTER)
        if ((FIGHTER_LASER_Y >= SCREEN_HEIGHT)); then
          erase-sprite-unmasked "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${HUNTER_LASER_SPRITE[@]}"
          unset FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]
          FIGHTER_LASERS=("${FIGHTER_LASERS[@]}")
          ((TOTAL_FIGHTER_LASERS--))
          continue
        elif object-collides-player ${P1} "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}"; then
          erase-sprite-unmasked "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${HUNTER_LASER_SPRITE[@]}"
          unset FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]
          FIGHTER_LASERS=("${FIGHTER_LASERS[@]}")
          ((TOTAL_FIGHTER_LASERS--))
          # Player consequences
          if ((P1_SHIELDS == 0)); then
            player-death ${P1}
          else
            sound shield-impact
          fi
          continue
        elif object-collides-player ${P2} "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}"; then
          erase-sprite-unmasked "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${HUNTER_LASER_SPRITE[@]}"
          unset FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]
          FIGHTER_LASERS=("${FIGHTER_LASERS[@]}")
          ((TOTAL_FIGHTER_LASERS--))
          # Player consequences
          if ((P2_SHIELDS == 0)); then
            player-death ${P2}
          else
            sound shield-impact
          fi
          continue
        elif ((ANIMATION_KEYFRAME % 2 == 0)); then
          ((FIGHTER_LASER_Y++))
          FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]="${FIGHTER_LASER_X} ${FIGHTER_LASER_Y} ${FIGHTER_LASER_TYPE} ${FIGHTER_LASER_TARGET_X} ${FIGHTER_LASER_TARGET_Y}"
          draw-sprite-unmasked "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${HUNTER_LASER_SPRITE[@]}"
        fi
        ;;
      $SNIPER)
        if ((FIGHTER_LASER_Y >= SCREEN_HEIGHT || FIGHTER_LASER_Y <= 1 || FIGHTER_LASER_X >= SCREEN_WIDTH || FIGHTER_LASER_X <= 0)); then
          erase-sprite-unmasked "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${SNIPER_LASER_SPRITE[@]}"
          unset FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]
          FIGHTER_LASERS=("${FIGHTER_LASERS[@]}")
          ((TOTAL_FIGHTER_LASERS--))
          continue
        elif object-collides-player ${P1} "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}"; then
          erase-sprite-unmasked "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${SNIPER_LASER_SPRITE[@]}"
          unset FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]
          FIGHTER_LASERS=("${FIGHTER_LASERS[@]}")
          ((TOTAL_FIGHTER_LASERS--))
          # Player consequences
          if ((P1_SHIELDS == 0)); then
            player-death ${P1}
          else
            sound shield-impact
          fi
          continue
        elif object-collides-player ${P2} "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}"; then
          erase-sprite-unmasked "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${SNIPER_LASER_SPRITE[@]}"
          unset FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]
          FIGHTER_LASERS=("${FIGHTER_LASERS[@]}")
          ((TOTAL_FIGHTER_LASERS--))
          # Player consequences
          if ((P2_SHIELDS == 0)); then
            player-death ${P2}
          else
            sound shield-impact
          fi
          continue
        elif ((ANIMATION_KEYFRAME % 3 == 0)); then
          if ((FIGHTER_LASER_X == FIGHTER_LASER_TARGET_X && FIGHTER_LASER_Y == FIGHTER_LASER_TARGET_Y)); then
            erase-sprite-unmasked "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${SNIPER_LASER_SPRITE[@]}"
            unset FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]
            FIGHTER_LASERS=("${FIGHTER_LASERS[@]}")
            ((TOTAL_FIGHTER_LASERS--))
          else
            DX=$((FIGHTER_LASER_TARGET_X - FIGHTER_LASER_X))
            DY=$((FIGHTER_LASER_TARGET_Y - FIGHTER_LASER_Y))
            ABSDX=${DX#-}
            ABSDY=${DY#-}
            if ((ABSDX < ABSDY)); then
              if ((DY < 0)); then
                ((FIGHTER_LASER_Y--))
              else
                ((FIGHTER_LASER_Y++))
              fi
            else
              if ((DX < 0)); then
                ((FIGHTER_LASER_X--))
              else
                ((FIGHTER_LASER_X++))
              fi
            fi
            FIGHTER_LASERS[${FIGHTER_LASER_LOOP}]="${FIGHTER_LASER_X} ${FIGHTER_LASER_Y} ${FIGHTER_LASER_TYPE} ${FIGHTER_LASER_TARGET_X} ${FIGHTER_LASER_TARGET_Y}"
            draw-sprite-masked "${FIGHTER_LASER_X}" "${FIGHTER_LASER_Y}" "${SNIPER_LASER_SPRITE[@]}"
          fi
        fi
        ;;
    esac
  done
}

fighter-ai() {
  local TOTAL_FIGHTERS=${#FIGHTERS[@]}
  local FIGHTER_LASER_COUNT=${#FIGHTER_LASERS[@]}
  local FIGHTER_INSTANCE=()
  local FIGHTER_X=0
  local FIGHTER_Y=2
  local TARGET_X=0
  local TARGET_Y=0
  local TARGET_PLAYER=0
  local FIGHTER_TYPE=0
  local FIGHTER_FRAME=0
  local FIGHTER_LOOP=0

  # Is it time to spawn a new alien fighter?
  if ((TOTAL_FIGHTERS < MAX_FIGHTERS)); then
    if ((RANDOM % ALIEN_SPAWN_RATE == 0)); then
      FIGHTER_X=$((RANDOM % FIGHTER_MAX_X))

      # What type of fighter will this be?
      if ((FIGHTER_X <= HUNT_REGION_LEFT || FIGHTER_X >= HUNT_REGION_RIGHT)); then
        FIGHTER_TYPE=${HUNTER}
      else
        FIGHTER_TYPE=${SNIPER}
      fi
      FIGHTERS+=("${FIGHTER_X} ${FIGHTER_Y} ${FIGHTER_TYPE} ${FIGHTER_FRAME}")
      ((TOTAL_FIGHTERS++))
      ((FIGHTERS_SPAWNED++))
    fi
  fi

  for (( FIGHTER_LOOP=0; FIGHTER_LOOP < TOTAL_FIGHTERS; FIGHTER_LOOP++ )); do
    FIGHTER_INSTANCE=(${FIGHTERS[${FIGHTER_LOOP}]})
    FIGHTER_X=${FIGHTER_INSTANCE[0]}
    FIGHTER_Y=${FIGHTER_INSTANCE[1]}
    FIGHTER_TYPE=${FIGHTER_INSTANCE[2]}
    FIGHTER_FRAME=${FIGHTER_INSTANCE[3]}

    if ((ANIMATION_KEYFRAME % LEVEL_COMPENSATION == 0)); then
      if ((FIGHTER_FRAME == 0)); then
        if ((FIGHTER_Y >= FIGHTER_MAX_Y)); then
          # Remove the fighter
          case ${FIGHTER_TYPE} in
            $HUNTER) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${HUNTER_SPRITE[@]}";;
            $SNIPER) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${SNIPER_SPRITE[@]}";;
          esac
          unset FIGHTERS[${FIGHTER_LOOP}]
          FIGHTERS=("${FIGHTERS[@]}")
          ((TOTAL_FIGHTERS--))
          ((FIGHTERS_ESCAPED++))
          continue
        elif object-collides-player ${P1} "$((FIGHTER_X + 3))" "$((FIGHTER_Y + 4))"; then
          # Remove the fighter
          case ${FIGHTER_TYPE} in
            $HUNTER) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${HUNTER_SPRITE[@]}";;
            $SNIPER) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${SNIPER_SPRITE[@]}";;
          esac
          FIGHTER_FRAME=1
          FIGHTERS[${FIGHTER_LOOP}]="${FIGHTER_X} ${FIGHTER_Y} ${FIGHTER_TYPE} ${FIGHTER_FRAME}"
          sound-explosion

          # Player consequences
          if ((P1_SHIELDS == 0)); then
            player-death ${P1}
          else
            sound shield-impact
          fi
          ((P1_KILLS++))
          player-increment-score ${P1} ${FIGHTER_POINTS}
          continue
        elif object-collides-player ${P2} "$((FIGHTER_X + 3))" "$((FIGHTER_Y + 4))"; then
          # Remove the fighter
          case ${FIGHTER_TYPE} in
            $HUNTER) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${HUNTER_SPRITE[@]}";;
            $SNIPER) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${SNIPER_SPRITE[@]}";;
          esac
          FIGHTER_FRAME=1
          FIGHTERS[${FIGHTER_LOOP}]="${FIGHTER_X} ${FIGHTER_Y} ${FIGHTER_TYPE} ${FIGHTER_FRAME}"
          sound-explosion

          # Player consequences
          if ((P2_SHIELDS == 0)); then
            player-death ${P2}
          else
            sound shield-impact
          fi
          ((P2_KILLS++))
          player-increment-score ${P1} ${FIGHTER_POINTS}
          continue
        else
          case ${FIGHTER_TYPE} in
            $HUNTER) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${HUNTER_SPRITE[@]}";;
            $SNIPER) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${SNIPER_SPRITE[@]}";;
          esac
          ((FIGHTER_Y++))

          # Go hunting
          if ((FIGHTER_TYPE == HUNTER)); then
            local HUNT_P1=0
            local HUNT_P2=0
            if ((P1_DEAD == 0 && P2_DEAD == 1)); then
              HUNT_P1=1
            elif ((P1_DEAD == 1 && P2_DEAD == 0)); then
              HUNT_P2=1
            elif ((P1_DEAD == 0 && P2_DEAD == 0)); then
              # Get distances
              DISTANCE_TO_P1=$((P1_X - FIGHTER_X))
              DISTANCE_TO_P2=$((P2_X - FIGHTER_X))
              # Get absolute distances
              P1_DISTANCE=${DISTANCE_TO_P1#-}
              P2_DISTANCE=${DISTANCE_TO_P2#-}
              if ((P1_DISTANCE < P2_DISTANCE)); then
                # P1 is nearest, hunt them down.
                HUNT_P1=1
              elif ((P2_DISTANCE < P1_DISTANCE)); then
                # P2 is nearest, hunt them down.
                HUNT_P2=1
              fi
            fi

            if ((HUNT_P1 == 1)); then
              if (( (FIGHTER_X - 1) <= P1_X)); then
                ((FIGHTER_X++))
              elif (( (FIGHTER_X - 1) >= P1_X)); then
                ((FIGHTER_X--))
              fi
            elif ((HUNT_P2 == 1)); then
              if (( (FIGHTER_X - 1 ) <= P2_X)); then
                ((FIGHTER_X++))
              elif (( (FIGHTER_X - 1 ) >= P2_X)); then
                ((FIGHTER_X--))
              fi
            else
              case $((RANDOM % 5)) in
                0) ((FIGHTER_X--));;
                4) ((FIGHTER_X++));;
              esac
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

          #FIGHTERS[${FIGHTER_LOOP}]="${FIGHTER_X} ${FIGHTER_Y} ${FIGHTER_TYPE} ${FIGHTER_FRAME}"
        fi
      fi

      # FIXME - Frame 1 is always skipped!
      # If the fighter is exploding, advanced the frame to be rendered.
      ((FIGHTER_FRAME >= 1)) && ((FIGHTER_FRAME++))

      FIGHTERS[${FIGHTER_LOOP}]="${FIGHTER_X} ${FIGHTER_Y} ${FIGHTER_TYPE} ${FIGHTER_FRAME}"

      # Render the appropriate fighter sprite.
      case ${FIGHTER_FRAME} in
        0) case ${FIGHTER_TYPE} in
              $HUNTER) draw-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${HUNTER_SPRITE[@]}";;
              $SNIPER) draw-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${SNIPER_SPRITE[@]}";;
            esac
            ;;
        1) draw-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${FIGHTER_EXPLODE1[@]}";;
        2) draw-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${FIGHTER_EXPLODE2[@]}";;
        3) draw-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${FIGHTER_EXPLODE3[@]}";;
        4) draw-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${FIGHTER_EXPLODE4[@]}";;
        6) erase-sprite-unmasked "${FIGHTER_X}" "${FIGHTER_Y}" "${FIGHTER_EXPLODE4[@]}"
          unset FIGHTERS[${FIGHTER_LOOP}]
          FIGHTERS=("${FIGHTERS[@]}")
          ((TOTAL_FIGHTERS--))
          ;;
      esac
    fi
    # Should the fighter unleash a laser?
    # Is the fighter alive, are there lasers available, is it time and is the fighter within the aiming window?
    if ((FIGHTER_FRAME == 0 && FIGHTER_LASER_COUNT < MAX_FIGHTER_LASERS && (RANDOM % ALIEN_FIRE_RATE == 0) && FIGHTER_Y <= FIGHTER_AIMING_FLOOR)); then
      case ${FIGHTER_TYPE} in
        $HUNTER)
          if (( FIGHTER_Y <= (P1_Y - P1_HEIGHT) || FIGHTER_Y <= (P2_Y - P2_HEIGHT) )); then
            sound fighter-laser
            FIGHTER_LASERS+=("$((FIGHTER_X + 1)) $((FIGHTER_Y + 3)) ${FIGHTER_TYPE} 0 0")
            ((FIGHTER_LASER_COUNT++))
          fi
          ;;
        $SNIPER)
          if ((P1_DEAD == 0 && P2_DEAD == 1)); then
            TARGET_PLAYER=1
          elif ((P1_DEAD == 1 && P2_DEAD == 0)); then
            TARGET_PLAYER=2
          else
            TARGET_PLAYER=$(((RANDOM % 2) + 1))
          fi
          case ${TARGET_PLAYER} in
            1) TARGET_X=$((P1_X + (P1_WIDTH / 2) ))
               TARGET_Y=$((P1_Y + (P1_HEIGHT / 2) ))
               sound fighter-laser
               FIGHTER_LASERS+=("$((FIGHTER_X + 1)) $((FIGHTER_Y + 3)) ${FIGHTER_TYPE} ${TARGET_X} ${TARGET_Y}")
               ((FIGHTER_LASER_COUNT++))
               ;;
            2) TARGET_X=$((P2_X + (P2_WIDTH / 2) ))
               TARGET_Y=$((P2_Y + (P2_HEIGHT / 2) ))
               sound fighter-laser
               FIGHTER_LASERS+=("$((FIGHTER_X + 1)) $((FIGHTER_Y + 3)) ${FIGHTER_TYPE} ${TARGET_X} ${TARGET_Y}")
               ((FIGHTER_LASER_COUNT++))
               ;;
          esac
          ;;
      esac
    fi
  done
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
    FIGHTER_TYPE=${FIGHTER_INSTANCE[2]}
    FIGHTER_FRAME=${FIGHTER_INSTANCE[3]}
    if ((LASER_X >= FIGHTER_X && LASER_X <= FIGHTER_X + FIGHTER_WIDTH && FIGHTER_FRAME == 0)); then
      if ((LASER_Y >= FIGHTER_Y && LASER_Y <= FIGHTER_Y + FIGHTER_HEIGHT)); then
        # Remove the fighter
        sound-explosion
        case ${FIGHTER_TYPE} in
          $HUNTER) erase-sprite-masked "${FIGHTER_X}" "${FIGHTER_Y}" "${HUNTER_SPRITE[@]}";;
          $SNIPER) erase-sprite-masked "${FIGHTER_X}" "${FIGHTER_Y}" "${SNIPER_SPRITE[@]}";;
        esac
        FIGHTER_FRAME=1
        FIGHTERS[${FIGHTER_LOOP}]="${FIGHTER_X} ${FIGHTER_Y} ${FIGHTER_TYPE} ${FIGHTER_FRAME}"
        spawn-bonus "${FIGHTER_X}" "${FIGHTER_Y}"
        return 0
      fi
    fi
  done
  return 1
}

player-lasers() {
  local PLAYER=${1}
  case ${PLAYER} in
    1) local TOTAL_LASERS=${#P1_LASERS[@]}
       local LASER_CEILING=${P1_LASER_CEILING}
       ;;
    2) local TOTAL_LASERS=${#P2_LASERS[@]}
       local LASER_CEILING=${P2_LASER_CEILING}
       ;;
  esac
  if ((TOTAL_LASERS > 0 && ANIMATION_KEYFRAME % 10 != 0)); then
    local LASER_INSTANCE=()
    local LASER_X=0
    local LASER_Y=0
    local LASER_LOOP=0
    for (( LASER_LOOP=0; LASER_LOOP < TOTAL_LASERS; LASER_LOOP++ )); do
      case ${PLAYER} in
        1) LASER_INSTANCE=(${P1_LASERS[${LASER_LOOP}]});;
        2) LASER_INSTANCE=(${P2_LASERS[${LASER_LOOP}]});;
      esac
      LASER_X=${LASER_INSTANCE[0]}
      LASER_Y=${LASER_INSTANCE[1]}
      if ((LASER_Y <= LASER_CEILING)); then
        case ${PLAYER} in
          1) erase-sprite-unmasked "${LASER_X}" "${LASER_Y}" "${P1_LASER_SPRITE[@]}"
            unset P1_LASERS[${LASER_LOOP}]
            P1_LASERS=("${P1_LASERS[@]}")
            ;;
          2) erase-sprite-unmasked "${LASER_X}" "${LASER_Y}" "${P2_LASER_SPRITE[@]}"
            unset P2_LASERS[${LASER_LOOP}]
            P2_LASERS=("${P2_LASERS[@]}")
            ;;
        esac
        ((TOTAL_LASERS--))
        continue
      elif player-laser-hit-fighter "${LASER_X}" "${LASER_Y}"; then
        case ${PLAYER} in
          1) erase-sprite-unmasked "${LASER_X}" "${LASER_Y}" "${P1_LASER_SPRITE[@]}"
            unset P1_LASERS[${LASER_LOOP}]
            P1_LASERS=("${P1_LASERS[@]}")
            ((P1_KILLS++))
            ;;
          2) erase-sprite-unmasked "${LASER_X}" "${LASER_Y}" "${P2_LASER_SPRITE[@]}"
            unset P2_LASERS[${LASER_LOOP}]
            P2_LASERS=("${P2_LASERS[@]}")
            ((P2_KILLS++))
            ;;
        esac
        ((TOTAL_LASERS--))
        player-increment-score ${PLAYER} ${FIGHTER_POINTS}
        continue
      else
        ((LASER_Y--))
        case ${PLAYER} in
          1) draw-sprite-unmasked "${LASER_X}" "${LASER_Y}" "${P1_LASER_SPRITE[@]}"
             P1_LASERS[$LASER_LOOP]="${LASER_X} ${LASER_Y}"
             ;;
          2) draw-sprite-unmasked "${LASER_X}" "${LASER_Y}" "${P2_LASER_SPRITE[@]}"
             P2_LASERS[$LASER_LOOP]="${LASER_X} ${LASER_Y}"
             ;;
        esac
      fi
    done
  fi
}

game-loop() {
  # Movement
  if ((P1_FRAME == 0)); then
    case ${KEY} in
      # Player 1
      'q')
        kill-thread ${GAME_MUSIC_THREAD}
        teardown
        ;;
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
      'x')
        if ((P1_RECENTLY_FIRED == 0 && P1_DEAD == 0)); then
          sound player1-laser
          case ${P1_FIRE_POWER} in
            1) P1_LASERS+=("$((P1_X + 4)) $((P1_Y - 1))")
               ;;
            2) P1_LASERS+=("$((P1_X + 3)) $((P1_Y - 1))")
               P1_LASERS+=("$((P1_X + 5)) $((P1_Y - 1))")
               ;;
            3) P1_LASERS+=("$((P1_X + 2)) $((P1_Y - 1))")
               P1_LASERS+=("$((P1_X + 4)) $((P1_Y - 1))")
               P1_LASERS+=("$((P1_X + 6)) $((P1_Y - 1))")
               ;;
          esac
          ((P1_RECENTLY_FIRED+=P1_LASER_LATENCY))
        fi
        P1_LAST_KEY=${KEY}
        ;;
    esac
  fi

  if ((P2_FRAME == 0)); then
    case ${KEY} in
    # Player 2
    'i')
      ((P2_Y--))
      # Prevent leaving the top of the screen
      ((P2_Y < 1)) && P2_Y=1
      P2_LAST_KEY=${KEY}
      ;;
    'k')
      ((P2_Y++))
      # Prevent leaving the bottom of the screen
      ((P2_Y > P2_MAX_Y)) && P2_Y=${P2_MAX_Y}
      P2_LAST_KEY=${KEY}
      ;;
    'j')
      ((P2_X--))
      # Prevent leaving screen left
      ((P2_X < 0)) && P2_X=0
      P2_LAST_KEY=${KEY}
      ;;
    'l')
      ((P2_X++))
      # Prevent leaving screne right
      ((P2_X > P2_MAX_X)) && P2_X=${P2_MAX_X}
      P2_LAST_KEY=${KEY}
      ;;
    ',')
      if ((P2_RECENTLY_FIRED == 0 && P2_DEAD == 0)); then
        sound player2-laser
        case ${P2_FIRE_POWER} in
          1) P2_LASERS+=("$((P2_X + 4)) $((P2_Y - 1))")
             ;;
          2) P2_LASERS+=("$((P2_X + 3)) $((P2_Y - 1))")
             P2_LASERS+=("$((P2_X + 5)) $((P2_Y - 1))")
             ;;
          3) P2_LASERS+=("$((P2_X + 2)) $((P2_Y - 1))")
             P2_LASERS+=("$((P2_X + 4)) $((P2_Y - 1))")
             P2_LASERS+=("$((P2_X + 6)) $((P2_Y - 1))")
             ;;
        esac
        ((P2_RECENTLY_FIRED+=P2_LASER_LATENCY))
      fi
      P2_LAST_KEY=${KEY}
      ;;
    esac
  fi
  KEY=

  # Regulate Player 1 laser fire frequency
  if [ "${P1_LAST_KEY}" != 'x' ]; then
    P1_RECENTLY_FIRED=0
  elif ((P1_RECENTLY_FIRED > 0)); then
    ((P1_RECENTLY_FIRED--))
  fi

  # Regulate Player 2 laser fire frequency
  if [ "${P2_LAST_KEY}" != ',' ]; then
    P2_RECENTLY_FIRED=0
  elif ((P2_RECENTLY_FIRED > 0)); then
    ((P2_RECENTLY_FIRED--))
  fi

  # Level up
  if ((P1_KILLS + P2_KILLS >= LEVEL_UP_KILLS)); then
    round-up
    level-up
  fi

  # Victory condition stub
  if ((LEVEL > LAST_LEVEL)); then
      kill-thread ${GAME_MUSIC_THREAD}
      victory-mode
      return 1
  fi

  # If player 1 is not registered dead but has no lives, then kill player 1.
  if ((P1_LIVES <= 0 && P1_DEAD == 0 && P1_FRAME == 0)); then
    erase-sprite-masked "${P1_X}" "${P1_Y}" "${P1_SPRITE[@]}"
    P1_DEAD=1
  fi

  # If player 2 is not registered dead but has no lives, then kill player 2.
  if ((P2_LIVES <= 0 && P2_DEAD == 0 && P2_FRAME == 0)); then
    erase-sprite-masked "${P2_X}" "${P2_Y}" "${P2_SPRITE[@]}"
    P2_DEAD=1
  fi

  # Game over condition
  if ((P1_DEAD == 1 && P2_DEAD == 1)); then
    kill-thread ${GAME_MUSIC_THREAD}
    gameover-mode
    return 1
  fi

  if ((P1_SHIELDS > 0)); then
    ((P1_SHIELDS--))
    if ((P1_SHIELDS == 0)); then
      if ((P1_RESPAWN == 0)); then
        sound shield-down
      fi
      P1_RESPAWN=0
    fi
  fi

  if ((P2_SHIELDS > 0)); then
    ((P2_SHIELDS--))
    if ((P2_SHIELDS == 0)); then
      if ((P2_RESPAWN == 0)); then
        sound shield-down
      fi
      P2_RESPAWN=0
    fi
  fi

  if ((P1_DEAD == 0)); then
    player-sprite ${P1}
  fi

  if ((P2_DEAD == 0)); then
    player-sprite ${P2}
  fi

  if ((ANIMATION_KEYFRAME % 5 == 0)); then
    if ((P1_FRAME > 0)); then
      ((P1_FRAME++))
    fi
    if ((P2_FRAME > 0)); then
      ((P2_FRAME++))
    fi
  fi

  compose-sprites
  animate-starfield
  bonuses
  fighter-lasers
  fighter-ai

  player-lasers ${P1}
  player-lasers ${P2}

  # These are quite expensive, only refresh them periodically
  if ((ANIMATION_KEYFRAME == 0)); then
    if ((P1_SCORE > HI_SCORE)); then
      HI_SCORE=${P1_SCORE}
      if ((P1_HI_SCORE_BEATEN == 0)); then
        P1_HI_SCORE_BEATEN=1
        sound new_highscore
      fi
    elif ((P2_SCORE > HI_SCORE)); then
      HI_SCORE=${P2_SCORE}
      if ((P2_HI_SCORE_BEATEN == 0)); then
        P2_HI_SCORE_BEATEN=1
        sound new_highscore
      fi
    fi
    P1_SCORE_PADDED=$(printf "%07d" ${P1_SCORE})
    P2_SCORE_PADDED=$(printf "%07d" ${P2_SCORE})
    HI_SCORE_PADDED=$(printf "%07d" ${HI_SCORE})
    P1_LIVES_SYMBOLS=$(repeat "♥" "${P1_LIVES}")"   "
    P2_LIVES_SYMBOLS="   "$(repeat "♥" "${P2_LIVES}")

    draw 0 0 "${RED}${BBLK}" "1UP ${P1_SCORE_PADDED}"
    draw-centered 0 "${WHT}${BBLK}" "HISCORE ${HI_SCORE_PADDED}"
    draw-right 0 "${blu}${BBLK}" "${P2_SCORE_PADDED} 2UP"
    draw 0 "${SCREEN_HEIGHT}" "${RED}${BBLK}" "LIVES ${P1_LIVES_SYMBOLS}"
    draw-right "${SCREEN_HEIGHT}" "${blu}${BBLK}" "${P2_LIVES_SYMBOLS} LIVES"
  fi
  render
  update-gfx-timers
}