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
    case ${TITLE_SCREEN_ATTRACT_MODE} in
      0) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "T H E   S T O R Y"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-----------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "The year is 2138. Planet Earth is under attack by aliens, and they're antsy!"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "You're a mercenary with a state of the art space fighter and a gun for hire."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "The United Federation of Planet Earth has hired you to dispatch the aliens"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "and restore calm."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "Your contact features performance-related pay. Earn money for each alien"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) "destroyed with financial penalties for each alien that escapes. Efficient use"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "of lasers is rewarded. Collect power-ups to enhance your ship and earn bonuses."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "Go get 'em!"
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      1) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "P L A Y E R 1   C O N T R O L S"
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
      2) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "P L A Y E R 2   C O N T R O L S"
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
      3) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "P O W E R   U P S"
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
      4) local HUNTER_X=$(( (SCREEN_WIDTH / 2) - (FIGHTER_WIDTH / 2) ))
         local HUNTER_Y=$(( SCREEN_HEIGHT / 2 + 2 ))
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "T H E   H U N T E R"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------"
         draw-sprite-unmasked ${HUNTER_X} ${HUNTER_Y} "${HUNTER_SPRITE[@]}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "Flies toward the nearest player ship."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 9)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Fires lasers in a straight line."
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      5) local SNIPER_X=$(( (SCREEN_WIDTH / 2) - (FIGHTER_WIDTH / 2) ))
         local SNIPER_Y=$(( SCREEN_HEIGHT / 2 + 2 ))
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "T H E   S N I P E R"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------"
         draw-sprite-unmasked ${SNIPER_X} ${SNIPER_Y} "${SNIPER_SPRITE[@]}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "Flies mostly in straight lines."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 9)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Fires homing missles."
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      6) local MANAGER_X=$(( (SCREEN_WIDTH / 2) - (BOSS_SMALL_WIDTH / 2) ))
         local MANAGER_Y=$(( SCREEN_HEIGHT / 2 + 2 ))
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "M A N A G E R   C L A S S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------"
         draw-sprite-unmasked ${MANAGER_X} ${MANAGER_Y} "${BOSS_SMALL_1[@]}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Evasive latreal flight path."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 12)) "Fires a modest salvo of lasers and homing missles."
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      7) local DIRECTOR_X=$(( (SCREEN_WIDTH / 2) - (BOSS_MEDIUM_WIDTH / 2) ))
         local DIRECTOR_Y=$(( SCREEN_HEIGHT / 2 + 2 ))
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "D I R E C T O R   C L A S S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "---------------------------"
         draw-sprite-unmasked ${DIRECTOR_X} ${DIRECTOR_Y} "${BOSS_MEDIUM_1[@]}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Evasive latreal flight path."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 12)) "Fires a considerable salvo of lasers and homing missles."
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      8) local PRESIDENT_X=$(( (SCREEN_WIDTH / 2) - (BOSS_LARGE_WIDTH / 2) ))
         local PRESIDENT_Y=$(( SCREEN_HEIGHT / 2 + 2 ))
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "E L   P R E S I D E N T E"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------"
         draw-sprite-unmasked ${PRESIDENT_X} ${PRESIDENT_Y} "${BOSS_LARGE_1[@]}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Evasive latreal flight path."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 12)) "Fires a devasting salvo of lasers and homing missles."
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      9) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "C O N F I G U R A T I O N"
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
     10) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "C R E D I T S"
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
  export TITLE_SCREEN_ATTRACT_MAX=500
  export TITLE_SCREEN_ATTRACT_COUNT=500
  export TITLE_SCREEN_ATTRACT_MODE=0
  export TITLE_SCREEN_ATTRACT_MODE_MAX=10

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
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
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
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
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
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "S = Toggle Sound: ${SFX_TOG}"
      fi
      cfg-save
    elif ((SFX_ENABLED == 0)); then
      SFX_ENABLED=1
      sound-setup
      sound switch-on
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
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
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) "F = Toggle FPS:   ${FPS_TOG}"
      fi
      cfg-save
    elif ((FPS_ENABLED == 0)); then
      FPS_ENABLED=1
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
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