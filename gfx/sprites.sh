#!/usr/bin/env bash

export P1_WIDTH=6
export P1_HEIGHT=7
export P2_WIDTH=6
export P2_HEIGHT=7

readonly THRUST=(
"$DEF  $ylw▀$DEF $ylw▀  "
"$DEF  $ylw$bred▓$DEF $ylw$bred▓$DEF  "
"$DEF  $red$bylw▓$DEF $red$bylw▓$DEF  "
)
export THRUST_FRAME=0
readonly THRUST_FRAMES=$(( ${#THRUST[@]} + 1 ))

export P1_LASER_SPRITE=(
"$RED▓"
"$RED▒"
"$RED░"
"$DEF "
)
readonly P1_LASER_HEIGHT=$(( ${#P1_LASER_SPRITE[@]} ))

export P2_LASER_SPRITE=(
"$BLU▓"
"$BLU▒"
"$BLU░"
"$DEF "
)
readonly P2_LASER_HEIGHT=$(( ${#P2_LASER_SPRITE[@]} ))

#      
#░▌ ▐░
#▀▒█▒▀
# ▀▀▀
#      
export FIGHTER_WIDTH=6
export FIGHTER_HEIGHT=5
readonly FIGHTER_SPRITE=(
"$DEF     "
"$blk$BWHT░$blk$BBLK▌$DEF $blk▐$blk$BWHT░"
"$MGN$BBLK▀$blk$BWHT▒$WHT█$blk$BWHT▒$MGN$BBLK▀"
"$DEF $WHT$BBLK▀$RED$BWHT▀$WHT$BBLK▀$DEF "
"$DEF     "
)

compose-sprites() {
#       
#   ▄   
#  ▄█▄  
# ▄███▄ 
#▐█████▌
#  ▀ ▀  
#       
  P1_SPRITE=(
  "$DEF       "
  "$DEF   $RED▄$DEF   "
  "$DEF  $blk▄$red█$blk▄  "
  "$DEF $RED▄$blk█$RED█$blk█$RED▄ "
  "$RED▐█$blk█$RED█$blk█$RED█▌"
  "${THRUST[$THRUST_FRAME]}"
  "$DEF       ")

  # This is a potential blue player
  #P2_SPRITE=(
  #  "$DEF       "
  #  "$DEF   $BLU▄$DEF   "
  #  "$DEF  $blk▄$blu█$blk▄  "
  #  "$DEF $BLU▄$blk█$BLU█$blk█$BLU▄ "
  #  "$BLU▐█$blk█$BLU█$blk█$BLU█▌"
  #  "${THRUST[$THRUST_FRAME]}"
  #  "$DEF       ")
  #fi

  # Increment the play thrust animation speed control
  [[ $THRUST_FRAME -ge $THRUST_FRAMES ]] && THRUST_FRAME=0 || ((THRUST_FRAME++))
}