#!/usr/bin/env bash

toggle-status(){
  export MUS_TOG="[ ♫ ]"
  export SFX_TOG="[ ♪ ]"
  export FPS_TOG="[ ≈ ]"
  if ((MUSIC_ENABLED == 0)); then
    MUS_TOG="[   ]"
  fi
  if ((SFX_ENABLED == 0)); then
    SFX_TOG="[   ]"
  fi
  if ((FPS_ENABLED == 0)); then
    FPS_TOG="[   ]"
  fi
}

attract-mode() {
  if ((TITLE_SCREEN_ATTRACT_COUNT >= TITLE_SCREEN_ATTRACT_MAX)); then
    blank-screen
    toggle-status
    P1_SHIELDS=0
    P2_SHIELDS=0
    HI_SCORE_PADDED=$(printf "%07d" ${HI_SCORE})
    draw-centered 0 "${WHT}${BBLK}" "HISCORE ${HI_SCORE_PADDED}"
    local SNIPER_X=$(( (SCREEN_WIDTH / 2) - (FIGHTER_WIDTH * 7) ))
    local SNIPER_Y=$(( (SCREEN_HEIGHT / 2) - (FIGHTER_HEIGHT * 2) ))
    local HUNTER_X=$(( (SCREEN_WIDTH / 2) + (FIGHTER_WIDTH * 6) ))
    local HUNTER_Y=$(( (SCREEN_HEIGHT / 2) - (FIGHTER_HEIGHT * 2) ))
    draw-sprite-unmasked ${HUNTER_X} ${HUNTER_Y} "${HUNTER_SPRITE[@]}"
    draw-sprite-unmasked ${SNIPER_X} ${HUNTER_Y} "${SNIPER_SPRITE[@]}"
    case ${TITLE_SCREEN_ATTRACT_MODE} in
      0) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "P L A Y E R 1   C O N T R O L S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "W"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "↑"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "A ←   → D"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "↓"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "[X] Unleash the lasers"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) ""
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      1) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "P L A Y E R 2   C O N T R O L S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "I"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "↑"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "J ←   → L"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "↓"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "K"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "[,] Unleash the lasers"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) ""
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      2) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "P O W E R   U P S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-----------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) ""
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "    $ylw\$   Bonus Points"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) ""
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "    $red♥   Extra Life  "
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) ""
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 6)) "    $cyn☼   Smart Bomb  "
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) ""
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "    $grn≡   Shields     "
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 9)) ""
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "    $mgn‼   Fire Power  "
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      3) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "C O N F I G U R A T I O N"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "M = Toggle Music: ${MUS_TOG}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "S = Toggle Sound: ${SFX_TOG}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) "F = Toggle FPS:   ${FPS_TOG}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) ""
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      4) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "C R E D I T S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Code: Martin Wimpress"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "Graphics: Agatha Wimpress"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "Music: Patrick de Arteaga"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "Sound: Kenney Vleugels & Viktor Hahn"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) ""
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
    esac
    ((TITLE_SCREEN_ATTRACT_MODE >= TITLE_SCREEN_ATTRACT_MODE_MAX)) && TITLE_SCREEN_ATTRACT_MODE=0 || ((TITLE_SCREEN_ATTRACT_MODE++))
  fi
  ((TITLE_SCREEN_ATTRACT_COUNT >= TITLE_SCREEN_ATTRACT_MAX)) && TITLE_SCREEN_ATTRACT_COUNT=0 || ((TITLE_SCREEN_ATTRACT_COUNT++))
}

title-mode() {
  export DELAY=0.0125
  export KEY=
  export TITLE_MUSIC_THREAD=
  export TITLE_SCREEN=()
  export TITLE_SCREEN_OFFSET=
  export TITLE_SCREEN_ATTRACT_MAX=200
  export TITLE_SCREEN_ATTRACT_COUNT=200
  export TITLE_SCREEN_ATTRACT_MODE=0
  export TITLE_SCREEN_ATTRACT_MODE_MAX=4

  reset-timers
  music title
  TITLE_MUSIC_THREAD=$!

  readarray -t TITLE_SCREEN < gfx/title.ans
  TITLE_SCREEN_LONGEST_LINE=$(wc -L gfx/title.txt | cut -d' ' -f1)
  TITLE_SCREEN_OFFSET=$(center ${TITLE_SCREEN_LONGEST_LINE})

  export LOOP=title-loop
}

title-loop() {
  if [[ $KEY == '1' ]] || [[ $KEY == '2' ]]; then
    kill-thread ${TITLE_MUSIC_THREAD}
    game-mode ${KEY}
  elif [[ $KEY == 'q' ]]; then
    kill-thread ${TITLE_MUSIC_THREAD}
    teardown
  elif [[ $KEY == 'm' ]]; then
    if ((MUSIC_ENABLED == 1)); then
      MUSIC_ENABLED=0
      music-setup
      kill-thread ${TITLE_MUSIC_THREAD}
      sound switch-off
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 4)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "M = Toggle Music: ${MUS_TOG}"
      fi
      cfg-save
    elif ((MUSIC_ENABLED == 0)); then
      MUSIC_ENABLED=1
      music-setup
      music title
      TITLE_MUSIC_THREAD=$!
      sound switch-on
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 4)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "M = Toggle Music: ${MUS_TOG}"
      fi
      cfg-save
    fi
  elif [[ $KEY == 's' ]]; then
    if ((SFX_ENABLED == 1)); then
      SFX_ENABLED=0
      sound-setup
      sound switch-off
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 4)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "S = Toggle Sound: ${SFX_TOG}"
      fi
      cfg-save
    elif ((SFX_ENABLED == 0)); then
      SFX_ENABLED=1
      sound-setup
      sound switch-on
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 4)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "S = Toggle Sound: ${SFX_TOG}"
      fi
      cfg-save
    fi
  elif [[ $KEY == 'f' ]]; then
    if ((FPS_ENABLED == 1)); then
      FPS_ENABLED=0
      fps-counter-erase
      sound switch-off
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 4)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) "F = Toggle FPS:   ${FPS_TOG}"
      fi
      cfg-save
    elif ((FPS_ENABLED == 0)); then
      FPS_ENABLED=1
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 4)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) "F = Toggle FPS:   ${FPS_TOG}"
      fi
      sound switch-on
      cfg-save
    fi
  else
    attract-mode
    wave-picture "${TITLE_SCREEN_OFFSET}" "${TITLE_SCREEN[@]}"
    compose-sprites
    local P1_X=$(( (SCREEN_WIDTH / 2) - (P1_WIDTH * 4) ))
    local P1_Y=$(( SCREEN_HEIGHT - (P1_HEIGHT * 2) ))
    local P2_X=$(( (SCREEN_WIDTH / 2) + (P2_WIDTH * 3) ))
    local P2_Y=$(( SCREEN_HEIGHT - (P2_HEIGHT * 2) ))
    draw-sprite-unmasked ${P1_X} ${P1_Y} "${P1_SPRITE[@]}"
    draw-sprite-unmasked ${P2_X} ${P2_Y} "${P2_SPRITE[@]}"
    render
  fi
  KEY=
}