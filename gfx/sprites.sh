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

compose-sprites() {
#       
#   ▄   
#  ▄█▄  
# ▄███▄ 
#▐█████▌
#  ▀ ▀  
#       
  export P1_SPRITE=(
  "$SPC       "
  "$SPC   $RED▄$SPC   "
  "$SPC  $blk▄$red█$blk▄  "
  "$SPC $RED▄$blk█$RED█$blk█$RED▄ "
  "$RED▐█$blk█$RED█$blk█$RED█▌"
  "${THRUST[${THRUST_FRAME}]}"
  "$SPC       ")

  # This is a potential blue player
  #export P2_SPRITE=(
  #  "$SPC       "
  #  "$SPC   $BLU▄$SPC   "
  #  "$SPC  $blk▄$blu█$blk▄  "
  #  "$SPC $BLU▄$blk█$BLU█$blk█$BLU▄ "
  #  "$BLU▐█$blk█$BLU█$blk█$BLU█▌"
  #  "${THRUST[${THRUST_FRAME}]}"
  #  "$SPC       ")
  #fi

  # Increment the play thrust animation speed control
  [[ ${THRUST_FRAME} -ge ${THRUST_FRAMES} ]] && THRUST_FRAME=0 || ((THRUST_FRAME++))
}