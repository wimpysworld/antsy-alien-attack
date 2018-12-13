#!/usr/bin/env bash

framebuffer=
# for A in $(seq 0 36); do perl -e "printf '%.0f ', cos($A / 3) * 3"; done
readonly sin=(3 3 2 2 1 -0 -1 -2 -3 -3 -3 -3 -2 -1 -0 1 2 2 3 3 3 2 1 1 -0 -1 -2 -3 -3 -3 -3 -2 -1 0 1 2 3)
readonly sinc=${#sin[@]}

#--------------------------------------------------------------------+
#Color picker, usage: printf ${BLD}${CUR}${RED}${BBLU}"Hello!)"${DEF}|
#-------------------------+--------------------------------+---------+
#       Text color        |       Background color         |         |
#-----------+-------------+--------------+-----------------+         |
# Base color|Lighter shade| Base color   | Lighter shade   |         |
#-----------+-------------+--------------+-----------------+         |
BLK='\e[30m'; blk='\e[90m'; BBLK='\e[40m'; bblk='\e[100m' #| Black   |
RED='\e[31m'; red='\e[91m'; BRED='\e[41m'; bred='\e[101m' #| Red     |
GRN='\e[32m'; grn='\e[92m'; BGRN='\e[42m'; bgrn='\e[102m' #| Green   |
YLW='\e[33m'; ylw='\e[93m'; BYLW='\e[43m'; bylw='\e[103m' #| Yellow  |
BLU='\e[34m'; blu='\e[94m'; BBLU='\e[44m'; bblu='\e[104m' #| Blue    |
MGN='\e[35m'; mgn='\e[95m'; BMGN='\e[45m'; bmgn='\e[105m' #| Magenta |
CYN='\e[36m'; cyn='\e[96m'; BCYN='\e[46m'; bcyn='\e[106m' #| Cyan    |
WHT='\e[37m'; wht='\e[97m'; BWHT='\e[47m'; bwht='\e[107m' #| White   |
#----------------------------------------------------------+---------+
# Effects                                                            |
#--------------------------------------------------------------------+
DEF='\e[0m'   #Default color and effects                             |
BLD='\e[1m'   #Bold\brighter                                         |
DIM='\e[2m'   #Dim\darker                                            |
CUR='\e[3m'   #Italic font                                           |
UND='\e[4m'   #Underline                                             |
INV='\e[7m'   #Inverted                                              |
COF='\e[?25l' #Cursor Off                                            |
CON='\e[?25h' #Cursor On                                             |
#--------------------------------------------------------------------+

resize-term() {
  local cols=$1
  local lines=$2
  resize -s "$cols" "$lines"
  stty cols "$cols"
  stty rows "$lines"
}

gfx-setup() {
  readonly ORIGINAL_TTY=$(stty -g)
  readonly ORIGINAL_SCREEN_WIDTH=$(tput cols)
  readonly ORIGINAL_SCREEN_HEIGHT=$(tput lines)

  stty raw -echo
  tput civis
  tput rmam

  # TODO - Perhaps set the terminal size to something game optimised?
  #resize-term 80 60

  readonly SCREEN_WIDTH=$(tput cols)
  readonly SCREEN_HEIGHT=$(tput lines)

  echo -ne "\e]0;Bash 'em Up!\007"
}

gfx-teardown() {
  stty "$ORIGINAL_TTY"

  # TODO - Restore original terminal size.
  #resize-term "$ORIGINAL_SCREEN_WIDTH" "$ORIGINAL_SCREEN_HEIGHT"
  tput cvvis
  tput smam
  tput sgr0
  tput clear
  echo -en "\e[0m"
}

function reset-timers() {
  # Second marker from which to measure FPS.
  # Set slightly in the future to let FPS settle on transitions
  SEC=$(( SECONDS + 2 ))
  # Lowest FPS reached
  LOW_FPS=999
  # Maximum FPS reached
  MAX_FPS=0
  # FPS counter
  FPSC=0
  # Frames rendered - used for sin wave
  FRAME=0
}

function fps-counter() {
  if [ $SECONDS -gt $SEC ]; then
    FPS=$FPSC
    [[ $FPS -gt $MAX_FPS ]] && MAX_FPS=$FPS
    [[ $FPS -lt $LOW_FPS ]] && LOW_FPS=$FPS
    SEC=$SECONDS
    FPSC=0
  else
    ((FPSC++))
  fi
  draw-right "$SCREEN_HEIGHT" "$wht$bblk" " FPS: $FPS LOW: $LOW_FPS MAX: $MAX_FPS "
}

render() {
  fps-counter
  echo -en "${framebuffer}"
  framebuffer=
  ((FRAME++))
}

draw() {
  local x=$1
  local y=$2
  local color=$3
  local str=${*:4}
  framebuffer="${framebuffer}\e[$((y+1));$((x+1))H\e[$color${str}\e[m"
}

raw-draw() {
  local x=$1
  local y=$2
  local str=${*:3}
  framebuffer="${framebuffer}\e[$((y+1));$((x+1))H${str}"
}

lol-draw() {
  local x=$1
  local y=$2
  local str=$(echo "$3" | lolcat -f -F 0.2)
  framebuffer="${framebuffer}\e[$((y+1));$((x+1))H${str}"
}

draw-centered() {
  local y=$1
  local color=$2
  local str=${*:3}
  local offset=$(center ${#str})
  draw "$offset" "$y" "$color" "$str"
}

raw-draw-centered() {
  local y=$1
  local str=${*:2}
  local offset=$(center ${#str})
  raw-draw "$offset" "$y" "$str"
}

lol-draw-centered() {
  local y=$1
  local str="$2"
  local offset=$(center ${#str})
  lol-draw "$offset" "$y" "$str"
}

draw-right() {
  local y=$1
  local color=$2
  local str=${*:3}
  local offset=$((SCREEN_WIDTH - ${#str}))
  draw "$offset" "$y" "$color" "$str"
}

raw-draw-right() {
  local y=$1
  local str=${*:2}
  local offset=$((SCREEN_WIDTH - ${#str}))
  raw-draw "$offset" "$y" "$str"
}


lol-draw-right() {
  local y=$1
  local str=${3}
  local offset=$((SCREEN_WIDTH - ${#str}))
  lol-draw "$offset" "$y" "$str"
}

wave-picture() {
  local offset=$1; shift
  local picture_arr=("$@")
  local y=1
  for line in "${picture_arr[@]}"; do
    local i=$(((FRAME / 2 + y) % sinc))
    local x=$((offset + sin["$i"]))
    # Technically correct, since it clears characters
    # raw-draw $x $y "\e[1K$line\e[K"
    # But my wave only increments 1 char per-cycle.
    raw-draw $x $y "$DEF $line $DEF"
    ((y++))
  done
}

draw-picture() {
  local x=$1
  local y=$2
  local filename=gfx/$3.ans
  local contents=()
  local offset=0
  readarray -t contents < "$filename"
  for line in "${contents[@]}"; do
    raw-draw "$x" "$((y+offset))" "$line"
    ((offset++))
  done
}

draw-sprite() {
  local x=$1; shift
  local y=$1; shift
  local sprite=("$@")
  local i=
  for (( i=0; i<${#sprite[@]}; i++ )); do
    # The spaces either side are to scrub old position.
    raw-draw "${x}" "$((y + i))" "$DEF ${sprite[$i]}$DEF "
  done
}

erase() {
  local x=$1
  local y=$2
  local len=$3
  framebuffer="${framebuffer}\e[$((y+1));$((x+1))H\e[${len}X"
}

repeat() {
  local c=$1
  local n=$2
  printf "%0.s$c" $(seq 1 "$n")
}

center() {
  local size=$1
  local padding=$(( (SCREEN_WIDTH-size) / 2 ))
  if ((padding < 0)); then ((padding = 0)); fi
  echo $padding
}
