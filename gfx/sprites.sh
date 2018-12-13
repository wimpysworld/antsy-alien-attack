#!/usr/bin/env bash

export THRUST_FRAME=0
export HERO_WIDTH=7
export HERO_HEIGHT=7

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

compose-sprites() {
#       
#   ▄   
#  ▄█▄  
# ▄███▄ 
#▐█████▌
#  ▀ ▀  
#       
HERO=(
"$DEF       "
"$DEF   $RED▄$DEF   "
"$DEF  $blk▄$red█$blk▄  "
"$DEF $RED▄$blk█$RED█$blk█$RED▄ "
"$RED▐█$blk█$RED█$blk█$RED█▌"
"${THRUST[$THRUST_FRAME]}"
"$DEF       ")

  [[ $THRUST_FRAME -ge 10 ]] && THRUST_FRAME=0 || ((THRUST_FRAME++))
}