#!/usr/bin/env bash

export PLAYER1_WIDTH=7
export PLAYER1_HEIGHT=7
export PLAYER2_WIDTH=7
export PLAYER2_HEIGHT=7

readonly THRUST=(
"$DEF  $ylw▀$DEF $ylw▀  "
"$DEF  $ylw▀$DEF $ylw▀  "
"$DEF  $ylw▀$DEF $ylw▀  "
"$DEF  $ylw$bred▓$DEF $ylw$bred▓$DEF  "
"$DEF  $ylw$bred▓$DEF $ylw$bred▓$DEF  "
"$DEF  $ylw$bred▓$DEF $ylw$bred▓$DEF  "
"$DEF  $red$bylw▓$DEF $red$bylw▓$DEF  "
"$DEF  $red$bylw▓$DEF $red$bylw▓$DEF  "
"$DEF  $red$bylw▓$DEF $red$bylw▓$DEF  "
)
export THRUST_FRAME=0
readonly THRUST_FRAMES=$(( ${#THRUST[@]} + 1 ))

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
    "$DEF  $blk▄$red█$blk▄  "
    "$DEF $BLU▄$blk█$BLU█$blk█$BLU▄ "
    "$BLU▐█$blk█$BLU█$blk█$BLU█▌"
    "${THRUST[$THRUST_FRAME]}"
    "$DEF       ")
  fi

  if (( FRAME % 2 )); then
    [[ $THRUST_FRAME -ge $THRUST_FRAMES ]] && THRUST_FRAME=0 || ((THRUST_FRAME++))
  fi
}