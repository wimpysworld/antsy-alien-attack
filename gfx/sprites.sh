#!/usr/bin/env bash

export PLAYER1_WIDTH=6
export PLAYER1_HEIGHT=7
export PLAYER2_WIDTH=6
export PLAYER2_HEIGHT=7

readonly THRUST=(
"$DEF  $ylw▀$DEF $ylw▀  "
"$DEF  $ylw$bred▓$DEF $ylw$bred▓$DEF  "
"$DEF  $red$bylw▓$DEF $red$bylw▓$DEF  "
)
export THRUST_FRAME=0
export THRUST_ANIM_SPEED=0
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
FIGHTER_SPRITE=(
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
  PLAYER1=(
  "$DEF       "
  "$DEF   $RED▄$DEF   "
  "$DEF  $blk▄$red█$blk▄  "
  "$DEF $RED▄$blk█$RED█$blk█$RED▄ "
  "$RED▐█$blk█$RED█$blk█$RED█▌"
  "${THRUST[$THRUST_FRAME]}"
  "$DEF       ")

  # This is a potential blue player
  if [ 1 -eq 0 ]; then
    PLAYER2=(
    "$DEF       "
    "$DEF   $BLU▄$DEF   "
    "$DEF  $blk▄$blu█$blk▄  "
    "$DEF $BLU▄$blk█$BLU█$blk█$BLU▄ "
    "$BLU▐█$blk█$BLU█$blk█$BLU█▌"
    "${THRUST[$THRUST_FRAME]}"
    "$DEF       ")
  fi

  # Increment the play thrust animation speed control
  #[[ $THRUST_ANIM_SPEED -ge 1 ]] && THRUST_ANIM_SPEED=0 || ((THRUST_ANIM_SPEED++))
  if [ $THRUST_ANIM_SPEED -eq 0 ]; then
    [[ $THRUST_FRAME -ge $THRUST_FRAMES ]] && THRUST_FRAME=0 || ((THRUST_FRAME++))
  fi
}