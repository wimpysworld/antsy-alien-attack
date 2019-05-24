#!/usr/bin/env bash

export P1_WIDTH=6
export P1_HEIGHT=7
export P2_WIDTH=6
export P2_HEIGHT=7

readonly THRUST=(
"$SPC  $ylw▀$SPC $ylw▀  "
"$SPC  $ylw$bred▓$SPC $ylw$bred▓$SPC  "
"$SPC  $red$bylw▓$SPC $red$bylw▓$SPC  "
)
export THRUST_FRAME=0
readonly THRUST_FRAMES=$(( ${#THRUST[@]} + 1 ))

export P1_LASER_SPRITE=(
"$RED▓"
"$RED▒"
"$RED░"
"$SPC "
)
readonly P1_LASER_HEIGHT=$(( ${#P1_LASER_SPRITE[@]} ))

export P2_LASER_SPRITE=(
"$BLU▓"
"$BLU▒"
"$BLU░"
"$SPC "
)
readonly P2_LASER_HEIGHT=$(( ${#P2_LASER_SPRITE[@]} ))

export FIGHTER_LASER_SPRITE=(
"$SPC "
"$MGN░"
"$MGN▒"
"$MGN▓"
)
readonly FIGHTER_LASER_HEIGHT=$(( ${#FIGHTER_LASER_SPRITE[@]} ))

#      
#░▌ ▐░
#▀▒█▒▀
# ▀▀▀
#      
export FIGHTER_WIDTH=6
export FIGHTER_HEIGHT=5
readonly FIGHTER_SPRITE=(
"$SPC     "
"$blk$BWHT░$blk$BBLK▌$SPC $blk▐$blk$BWHT░"
"$MGN$BBLK▀$blk$BWHT▒$WHT█$blk$BWHT▒$MGN$BBLK▀"
"$SPC $WHT$BBLK▀$RED$BWHT▀$WHT$BBLK▀$SPC "
"$SPC     "
)

# 4 explosion frames
readonly FIGHTER_EXPLODE1=(
"$SPC     "
"$wht$BBLK▓▓▓▓▓"
"$wht$BBLK▓▓▓▓▓"
"$wht$BBLK▓▓▓▓▓"
"$SPC     "
)

readonly FIGHTER_EXPLODE2=(
"$SPC     "
"$ylw$BBLK▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓"
"$SPC     "
)

readonly FIGHTER_EXPLODE3=(
"$SPC     "
"$ylw$BBLK▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒"
"$SPC     "
)

readonly FIGHTER_EXPLODE4=(
"$SPC     "
"$ylw$BBLK░░░░░"
"$ylw$BBLK░░░░░"
"$ylw$BBLK░░░░░"
"$SPC     "
)
compose-sprites() {
#       
#   ▄   
#  ▄█▄  
# ▄███▄ 
#▐█████▌
#  ▀ ▀  
#       

  local COL1=$RED
  local COL2=$BLU

  # If a player ship has shields flash the ship.
  if ((P1_SHIELDS > 0 || P2_SHIELDS > 0)); then
    case ${THRUST_FRAME} in
        1) ((P1_SHIELDS > 0)) && COL1=$RED
        ((P2_SHIELDS > 0)) && COL2=$BLU
        ;;
        2) ((P1_SHIELDS > 0)) && COL1=$red
        ((P2_SHIELDS > 0)) && COL2=$blu
        ;;
        3) ((P1_SHIELDS > 0)) && COL1=$wht
        ((P2_SHIELDS > 0)) && COL2=$wht
        ;;
    esac
  fi

export P1_SPRITE=(
"$SPC       "
"$SPC   $COL1▄$SPC   "
"$SPC  $blk▄$red█$blk▄  "
"$SPC $COL1▄$blk█$COL1█$blk█$COL1▄ "
"$COL1▐█$blk█$COL1█$blk█$COL1█▌"
"${THRUST[${THRUST_FRAME}]}"
"$SPC       ")

export P2_SPRITE=(
"$SPC       "
"$SPC   $COL2▄$SPC   "
"$SPC  $blk▄$blu█$blk▄  "
"$SPC $COL2▄$blk█$COL2█$blk█$COL2▄ "
"$COL2▐█$blk█$COL2█$blk█$COL2█▌"
"${THRUST[${THRUST_FRAME}]}"
"$SPC       ")

  # Increment the play thrust animation speed control
  [[ ${THRUST_FRAME} -ge ${THRUST_FRAMES} ]] && THRUST_FRAME=0 || ((THRUST_FRAME++))
}