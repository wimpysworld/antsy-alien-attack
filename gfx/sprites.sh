#!/usr/bin/env bash

readonly STAR_0=(
"$SPC "
"$WHT·"
)

readonly STAR_1=(
"$SPC "
"$WHT•"
)

readonly STAR_2=(
"$SPC "
"$WHT+"
)

readonly STAR_3=(
"$SPC "
"$wht·"
)

readonly STAR_4=(
"$SPC "
"$wht•"
)

readonly STAR_5=(
"$SPC "
"$wht+"
)

readonly STAR_6=(
"$SPC "
"$blk·"
)

readonly STAR_7=(
"$SPC "
"$blk•"
)

readonly STAR_8=(
"$SPC "
"$blk+"
)

readonly P1_LASER_SPRITE=(
"$RED▓"
"$RED▒"
"$RED░"
"$SPC "
)
readonly P1_LASER_HEIGHT=$(( ${#P1_LASER_SPRITE[@]} ))

readonly P2_LASER_SPRITE=(
"$BLU▓"
"$BLU▒"
"$BLU░"
"$SPC "
)
readonly P2_LASER_HEIGHT=$(( ${#P2_LASER_SPRITE[@]} ))

readonly HUNTER_LASER_SPRITE=(
"$SPC "
"$MGN░"
"$MGN▒"
"$MGN▓"
)
readonly HUNTER_LASER_HEIGHT=$(( ${#HUNTER_LASER_SPRITE[@]} ))

readonly SNIPER_LASER_SPRITE=(
"$SPC "
"$grn$BGRN■"
"$SPC "
)
readonly SNIPER_LASER_HEIGHT=$(( ${#SNIPER_LASER_SPRITE[@]} ))

#      
#░▌ ▐░
#▀▒█▒▀
# ▀▀▀
#      
readonly HUNTER_SPRITE=(
"$blk$BWHT░$blk$BBLK▌$SPC $blk▐$blk$BWHT░"
"$MGN$BBLK▀$blk$BWHT▒$WHT█$blk$BWHT▒$MGN$BBLK▀"
"$SPC $WHT$BBLK▀$RED$BWHT▀$WHT$BBLK▀"
)

readonly SNIPER_SPRITE=(
"$blk$BWHT░$blk$BBLK▌$SPC $blk▐$blk$BWHT░"
"$GRN$BBLK▀$blk$BWHT▒$WHT█$blk$BWHT▒$GRN$BBLK▀"
"$SPC $WHT$BBLK▀$RED$BWHT▀$WHT$BBLK▀"
)
export FIGHTER_WIDTH=5
export FIGHTER_HEIGHT=${#FIGHTER_SNIPER[@]}

export BOSS_SMALL_WIDTH=10
export BOSS_SMALL_HEIGHT=5
export BOSS_MEDIUM_WIDTH=21
export BOSS_MEDIUM_HEIGHT=8
export BOSS_LARGE_WIDTH=43
export BOSS_LARGE_HEIGHT=8

readonly BOSS_SMALL_1=(
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓"
)

readonly BOSS_SMALL_2=(
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓"
)

readonly BOSS_SMALL_3=(
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒"
)

readonly BOSS_SMALL_4=(
"$ylw$BBLK░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░"
)

readonly BOSS_MEDIUM_1=(
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
)

readonly BOSS_MEDIUM_2=(
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
)

readonly BOSS_MEDIUM_3=(
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
)

readonly BOSS_MEDIUM_4=(
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░")

readonly BOSS_LARGE_1=(
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓")

readonly BOSS_LARGE_2=(
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓")

readonly BOSS_LARGE_3=(
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒")

readonly BOSS_LARGE_4=(
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
"$ylw$BBLK░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░")

readonly FIGHTER_EXPLODE1=(
"$WHT$BBLK▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓"
)

readonly FIGHTER_EXPLODE2=(
"$ylw$BBLK▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓"
)

readonly FIGHTER_EXPLODE3=(
"$ylw$BBLK▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒"
)

readonly FIGHTER_EXPLODE4=(
"$ylw$BBLK░░░░░"
"$ylw$BBLK░░░░░"
"$ylw$BBLK░░░░░"
)

# 5 player 1 explosion frames
readonly P1_EXPLODE1=(
"$SPC       "
"$WHT$BBLK▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓"
"$SPC       ")

readonly P1_EXPLODE2=(
"$SPC       "
"$wht$BBLK▓▓▓▓▓▓▓"
"$wht$BBLK▓▓▓▓▓▓▓"
"$wht$BBLK▓▓▓▓▓▓▓"
"$wht$BBLK▓▓▓▓▓▓▓"
"$wht$BBLK▓▓▓▓▓▓▓"
"$SPC       ")

readonly P1_EXPLODE3=(
"$SPC       "
"$ylw$BBLK▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓"
"$SPC       ")

readonly P1_EXPLODE4=(
"$SPC       "
"$ylw$BBLK▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒"
"$SPC       ")

readonly P1_EXPLODE5=(
"$SPC       "
"$ylw$BBLK░░░░░░░"
"$ylw$BBLK░░░░░░░"
"$ylw$BBLK░░░░░░░"
"$ylw$BBLK░░░░░░░"
"$ylw$BBLK░░░░░░░"
"$SPC       ")

# 5 player 2 explosion frames
readonly P2_EXPLODE1=(
"$SPC       "
"$WHT$BBLK▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓"
"$WHT$BBLK▓▓▓▓▓▓▓"
"$SPC       ")

readonly P2_EXPLODE2=(
"$SPC       "
"$wht$BBLK▓▓▓▓▓▓▓"
"$wht$BBLK▓▓▓▓▓▓▓"
"$wht$BBLK▓▓▓▓▓▓▓"
"$wht$BBLK▓▓▓▓▓▓▓"
"$wht$BBLK▓▓▓▓▓▓▓"
"$SPC       ")

readonly P2_EXPLODE3=(
"$SPC       "
"$ylw$BBLK▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓"
"$ylw$BBLK▓▓▓▓▓▓▓"
"$SPC       ")

readonly P2_EXPLODE4=(
"$SPC       "
"$ylw$BBLK▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒"
"$ylw$BBLK▒▒▒▒▒▒▒"
"$SPC       ")

readonly P2_EXPLODE5=(
"$SPC       "
"$ylw$BBLK░░░░░░░"
"$ylw$BBLK░░░░░░░"
"$ylw$BBLK░░░░░░░"
"$ylw$BBLK░░░░░░░"
"$ylw$BBLK░░░░░░░"
"$SPC       ")

export P1_WIDTH=7
export P1_HEIGHT=7
export P2_WIDTH=7
export P2_HEIGHT=7

readonly THRUST=(
"$SPC  $ylw▀$SPC $ylw▀$SPC  "
"$SPC  $ylw$bred▓$SPC $ylw$bred▓$SPC  "
"$SPC  $red$bylw▓$SPC $red$bylw▓$SPC  "
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

  local HIT=${WHT}

  # Impact flashes when boss ships take laser fire
  if ((BOSS_FIGHT == 1 && BOSS_HIT == 1 && ANIMATION_KEYFRAME % LEVEL_COMPENSATION == 0)); then
    case ${THRUST_FRAME} in
        1) HIT=${ylw}
           ((BOSS_HIT ^= 1))
           ;;
        2) HIT=${YLW}
           ((BOSS_HIT ^= 1))
           ;;
        3) HIT=${wht}
           ((BOSS_HIT ^= 1))
           ;;
    esac
  fi

export P1_SPRITE=(
"$SPC       "
"$SPC   $COL1▄$SPC "
"$SPC  $blk▄$red█$blk▄$SPC "
"$SPC $COL1▄$blk█$COL1█$blk█$COL1▄$SPC "
"$COL1▐█$blk█$COL1█$blk█$COL1█▌$SPC "
"${THRUST[${THRUST_FRAME}]}"
"$SPC       ")

export P2_SPRITE=(
"$SPC       "
"$SPC   $COL2▄$SPC "
"$SPC  $blk▄$blu█$blk▄$SPC "
"$SPC $COL2▄$blk█$COL2█$blk█$COL2▄$SPC "
"$COL2▐█$blk█$COL2█$blk█$COL2█▌$SPC "
"${THRUST[${THRUST_FRAME}]}"
"$SPC       ")

case ${BOSS_TYPE} in
# Management Class
# ▒  ▒▒  ▒
#▒█▒▄██▄▒█▒
#███▄██▄███
#▀◘▀ ▀▀ ▀◘▀
#▀▀▀    ▀▀▀
  0) export BOSS_SMALL_0=(
"$SPC $WHT$BBLK▓$SPC  $WHT$BBLK▓▓$SPC  $WHT$BBLK▓$SPC  "
"$WHT$BBLK▓$HIT█$WHT$BBLK▓$blk$BBLK▄$HIT██$blk$BBLK▄$WHT$BBLK▓$HIT█$WHT$BBLK▓"
"$HIT███$blk$BBLK▄$HIT██$blk$BBLK▄$HIT███"
"$HIT█$MGN$BBLK◘$HIT█$SPC $GRN$BWHT▀▀$SPC $HIT█$MGN$BBLK◘$HIT█"
"$HIT$BBLK▀▀▀$SPC    $HIT$BBLK▀▀▀");;
# Director Class
# ░░░░░         ░░░░░
#░░▒▒▒░░  ░░░  ░░▒▒▒░░
#░▒███▒░▄░▒▒▒░▄░▒███▒░
#▒█████▒ ▒▒█▒▒ ▒█████▒
#▒█████▒ ▒███▒ ▒█████▒
#▒█████▒▄█◘◘◘█▄▒█████▒
#█◘◘█◘◘█  ▀▀▀  █◘◘█◘◘█
# ▀▀▀▀▀         ▀▀▀▀▀
  1) export BOSS_MEDIUM_0=(
"$SPC $blk$BBLK░░░░░$SPC         $blk$BBLK░░░░░"
"$blk$BBLK░░$WHT$BBLK▒▒▒$blk$BBLK░░$SPC  $blk$BBLK░░░$SPC  $blk$BBLK░░$WHT$BBLK▒▒▒$blk$BBLK░░"
"$blk$BBLK░$HIT$BBLK▒███▒$blk$BBLK░▄░▒▒▒$blk$BBLK░▄░$HIT$BBLK▒███▒$blk$BBLK░"
"$WHT$BBLK▓$HIT$BBLK█████$WHT$BBLK▓$SPC $WHT$BBLK▓▓$HIT$BBLK█$WHT$BBLK▓▓$SPC $WHT$BBLK▓$HIT$BBLK█████$WHT$BBLK▓"
"$WHT$BBLK▓$GRN█████$WHT$BBLK▓$SPC $WHT$BBLK▓$HIT$BBLK███$WHT$BBLK▓$SPC $WHT$BBLK▓$GRN█████$WHT$BBLK▓"
"$WHT$BBLK▓$HIT$BBLK█████$WHT$BBLK▓$blk$BBLK▄$HIT$BBLK█$MGN◘◘◘$HIT$BBLK█$blk$BBLK▄$WHT$BBLK▓$HIT$BBLK█████$WHT$BBLK▓"
"$HIT$BBLK█$MGN◘◘$HIT$BBLK█$MGN◘◘$HIT$BBLK█$SPC  $HIT$BBLK▀▀▀$SPC  $HIT$BBLK█$MGN◘◘$HIT$BBLK█$MGN◘◘$HIT$BBLK█"
"$SPC $HIT$BBLK▀▀▀▀▀$SPC         $HIT$BBLK▀▀▀▀▀");;
# El Presidente
#               ░░░░░   ░░░░░
# ░░░   ░░░    ░░▒▒▒░░ ░░▒▒▒░░    ░░░   ░░░
#░▒▒▒░▄░▒▒ ░▄▄▄░▒███▒░▄░▒███▒░▄▄▄░▒▒▒░▄░▒▒▒░
#▒▒█▒▒ ▒▒█▒▒ █ ▒█████▒ ▒█████▒ █ ▒▒█▒▒ ▒▒█▒▒
#▒███▒▄▒███▒▄█▄▒█████▒ ▒█████▒▄█▄▒███▒▄▒███▒
#█◘◘◘█ █◘◘◘█   ▒█████▒ ▒█████▒   █◘◘◘█ █◘◘◘█
# ▀▀▀   ▀▀▀    ███████ ███████    ▀▀▀   ▀▀▀
#               ▀▀▀▀▀   ▀▀▀▀▀
  *) export BOSS_LARGE_0=(
"$SPC               $blk$BBLK░░░░░$SPC   $blk$BBLK░░░░░"
"$SPC $blk$BBLK░░░$SPC   $blk$BBLK░░░$SPC    $blk$BBLK░░$WHT$BBLK▒▒▒$blk$BBLK░░$SPC $blk$BBLK░░$WHT$BBLK▒▒▒$blk$BBLK░░$SPC    $blk$BBLK░░░$SPC   $blk$BBLK░░░"
"$blk$BBLK░▒▒▒$blk$BBLK░▄$blk$BBLK░▒▒▒$blk$BBLK░▄▄▄$blk$BBLK░$WHT$BBLK▒$HIT$BBLK███$WHT$BBLK▒$blk$BBLK░▄░$WHT$BBLK▒$HIT$BBLK███$WHT$BBLK▒$blk$BBLK░▄▄▄$blk$BBLK░▒▒▒$blk$BBLK░▄░▒▒▒$blk$BBLK░"
"$WHT$BBLK▓▓$HIT$BBLK█$WHT$BBLK▓▓$SPC $WHT$BBLK▓▓$HIT$BBLK█$WHT$BBLK▓▓$SPC $blk$BBLK█$SPC $WHT$BBLK▓$HIT$BBLK█████$WHT$BBLK▓$SPC $WHT$BBLK▓$HIT$BBLK█████$WHT$BBLK▓$SPC $blk$BBLK█$SPC $WHT$BBLK▓▓$HIT$BBLK█$WHT$BBLK▓▓$SPC $WHT$BBLK▓▓$HIT$BBLK█$WHT$BBLK▓▓"
"$WHT$BBLK▓$HIT$BBLK███$WHT$BBLK▓$blk$BBLK▄$WHT$BBLK▓$HIT$BBLK███$WHT$BBLK▓$blk$BBLK▄█▄$WHT$BBLK▓$GRN█████$WHT$BBLK▓$SPC $WHT$BBLK▓$GRN█████$WHT$BBLK▓$blk$BBLK▄█▄$WHT$BBLK▓$HIT$BBLK███$WHT$BBLK▓$blk$BBLK▄$WHT$BBLK▓$HIT$BBLK███$WHT$BBLK▓"
"$HIT$BBLK█$MGN◘◘◘$HIT$BBLK█$SPC $HIT$BBLK█$MGN◘◘◘$HIT$BBLK█$SPC   $WHT$BBLK▓$HIT$BBLK█████$WHT$BBLK▓$SPC $WHT$BBLK▓$HIT$BBLK█████$WHT$BBLK▓$SPC   $HIT$BBLK█$MGN◘◘◘$HIT$BBLK█$SPC $HIT$BBLK█$MGN◘◘◘$HIT$BBLK█"
"$SPC $HIT$BBLK▀▀▀$SPC   $HIT$BBLK▀▀▀$SPC    $HIT$BBLK█$MGN◘◘$HIT$BBLK█$MGN◘◘$HIT$BBLK█$SPC $HIT$BBLK█$MGN◘◘$HIT$BBLK█$MGN◘◘$HIT$BBLK█$SPC    $HIT$BBLK▀▀▀$SPC   $HIT$BBLK▀▀▀"
"$SPC               $HIT$BBLK▀▀▀▀▀$SPC   $HIT$BBLK▀▀▀▀▀");;
esac

  # Increment the play thrust animation speed control
  ((THRUST_FRAME >= THRUST_FRAMES)) && THRUST_FRAME=0 || ((THRUST_FRAME++))
}