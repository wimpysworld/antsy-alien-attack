#!/usr/bin/env bash

export FRAME_BUFFER=

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
SPC="${BLK}${BBLK}"

resize-term() {
  local COLS=${1}
  local LINES=${2}
  resize -s "${COLS}" "${LINES}"
  stty cols "${COLS}"
  stty rows "${LINES}"
}

gfx-setup() {
  # for A in $(seq 0 36); do perl -e "printf '%.0f ', cos($A / 3) * 3"; done
  readonly SIN=(3 3 2 2 1 -0 -1 -2 -3 -3 -3 -3 -2 -1 -0 1 2 2 3 3 3 2 1 1 -0 -1 -2 -3 -3 -3 -3 -2 -1 0 1 2 3)
  readonly SIN_SIZE=${#SIN[@]}

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

  echo -ne "\e]0;${GAME_TITLE}\007"
}

gfx-teardown() {
  stty "${ORIGINAL_TTY}"

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
  SEC=$((SECONDS + 1))
  # Lowest FPS reached
  LOW_FPS=999
  # Maximum FPS reached
  MAX_FPS=0
  # FPS counter
  FPSC=0
  # Frames rendered by wave-pictre()
  WAVE_CYCLE=0
}

function fps-counter-erase() {
  draw-centered "${SCREEN_HEIGHT}" "$blk$BBLK" "                                   "
}

function fps-counter() {
  if ((FPS_ENABLED == 1 && SECONDS > SEC)); then
    FPS=${FPSC}
    ((FPS > MAX_FPS)) && MAX_FPS=${FPS}
    ((FPS < LOW_FPS)) && LOW_FPS=${FPS}
    SEC=${SECONDS}
    FPSC=0
    draw-centered "${SCREEN_HEIGHT}" "$blk$BBLK" " FPS: ${FPS} LOW: ${LOW_FPS} MAX: ${MAX_FPS} "
  else
    ((FPSC++))
  fi
}

render() {
  fps-counter
  echo -en "${FRAME_BUFFER}"
  unset FRAME_BUFFER
}

draw() {
  local X=$(( ${1}+1 ))
  local Y=$(( ${2}+1 ))
  local COLOR=${3}
  local STR=${*:4}
  FRAME_BUFFER="${FRAME_BUFFER}\e[${Y};${X}H\e[$COLOR${STR}\e[m"
}

blank-screen() {
  local Y=0
  local STR=
  STR=$(repeat " " "${SCREEN_WIDTH}")
  for ((Y=0; Y < SCREEN_HEIGHT; Y++)); do
    draw "0" "${Y}" "${SPC}" "${STR}"
  done
}

raw-draw() {
  local X=$(( ${1}+1 ))
  local Y=$(( ${2}+1 ))
  local STR=${3}
  FRAME_BUFFER="${FRAME_BUFFER}\e[${Y};${X}H${STR}"
}

lol-draw() {
  local X=$(( ${1}+1 ))
  local Y=$(( ${2}+1 ))
  local STR=
  STR=$(echo "${3}" | lolcat -f -F 0.2)
  FRAME_BUFFER="${FRAME_BUFFER}\e[${Y};${X}H${STR}"
}

draw-centered() {
  local Y=${1}
  local COLOR=${2}
  local STR=${*:3}
  local OFFSET=
  OFFSET=$(center ${#STR})
  draw "${OFFSET}" "${Y}" "${COLOR}" "${STR}"
}

raw-draw-centered() {
  local Y=${1}
  local STR=${*:2}
  local OFFSET=
  OFFSET=$(center ${#STR})
  raw-draw "${OFFSET}" "${Y}" "${STR}"
}

lol-draw-centered() {
  local Y=${1}
  local STR="${2}"
  local OFFSET=
  OFFSET=$(center ${#STR})
  lol-draw "${OFFSET}" "${Y}" "${STR}"
}

draw-right() {
  local Y=${1}
  local COLOR=${2}
  local STR=${*:3}
  local OFFSET=
  OFFSET=$((SCREEN_WIDTH - ${#STR}))
  draw "${OFFSET}" "${Y}" "${COLOR}" "${STR}"
}

raw-draw-right() {
  local Y=${1}
  local STR=${*:2}
  local OFFSET=
  OFFSET=$((SCREEN_WIDTH - ${#STR}))
  raw-draw "${OFFSET}" "${Y}" "${STR}"
}


lol-draw-right() {
  local Y=${1}
  local STR=${2}
  local OFFSET=
  OFFSET=$((SCREEN_WIDTH - ${#STR}))
  lol-draw "${OFFSET}" "${Y}" "${STR}"
}

wave-picture() {
  local OFFSET=${1}; shift
  local PICTURE=("$@")
  local X=0
  local Y=1
  local i=0
  for LINE in "${PICTURE[@]}"; do
    i=$(((WAVE_CYCLE / 2 + Y) % SIN_SIZE))
    X=$((OFFSET + SIN["${i}"]))
    # Technically correct, since it clears characters
    # raw-draw $x $y "\e[1K$line\e[K"
    # But my wave only increments 1 char per-cycle.
    raw-draw ${X} ${Y} "${SPC} ${LINE}${SPC} "
    ((Y++))
  done
  ((WAVE_CYCLE++))
}

draw-picture() {
  local X=${1}
  local Y=${2}
  local FILENAME=gfx/${3}.ans
  local CONTENT=()
  local OFFSET=0
  readarray -t CONTENT < "${FILENAME}"
  for LINE in "${CONTENT[@]}"; do
    raw-draw "${X}" "$((Y+OFFSET))" "${SPC}${LINE}"
    ((OFFSET++))
  done
}

draw-sprite() {
  local MASK=${1}; shift
  local X=${1}; shift
  local Y=${1}; shift
  local SPRITE=("$@")
  local i=
  for (( i=0; i< ${#SPRITE[@]}; i++ )); do
    if ((MASK == 1)); then
      # The spaces either side are to scrub old position.
      raw-draw "${X}" "$((Y + i))" "$SPC ${SPRITE[${i}]}$SPC "
    else
      raw-draw "${X}" "$((Y + i))" "${SPRITE[${i}]}"
    fi
  done
}

erase-sprite() {
  local MASK=${1}; shift
  local X=${1}; shift
  local Y=${1}; shift
  local SPRITE=("$@")
  local i=
  local ERASE=""
  ERASE=$(repeat " " "${#SPRITE[0]}")
  for (( i=0; i < ${#SPRITE[@]}; i++ )); do
    if (( MASK == 1 )); then
      # The spaces either side are to scrub old position.
      raw-draw "${X}" "$((Y + i))" "$SPC ${ERASE}$SPC "
    else
      raw-draw "${X}" "$((Y + i))" "${SPC}${ERASE}"
    fi
  done
}

erase() {
  local X=$(( ${1}+1 ))
  local Y=$(( ${2}+1 ))
  local LEN=${3}
  FRAME_BUFFER="${FRAME_BUFFER}\e[${Y};${X}H\e[${LEN}X"
}

repeat() {
  local CHAR=${1}
  local NUM=${2}
  if ((NUM == 0)); then
    echo ""
  else
    printf "%0.s${CHAR}" $(seq 1 "${NUM}")
  fi
}

center() {
  local SIZE=${1}
  local PADDING=$(( (SCREEN_WIDTH - SIZE) / 2 ))
  if ((PADDING < 0)); then
    PADDING=0
  fi
  echo "${PADDING}"
}

a-star-is-born() {
  local START_Y=${1}
  NEW_STAR_X=$((RANDOM % SCREEN_WIDTH))
  if (( START_Y != 0 )); then
    NEW_STAR_Y=0
  else
    NEW_STAR_Y=$((RANDOM % STAR_FLOOR))
  fi
  NEW_STAR_SPRITE_INDEX=$((RANDOM % NUM_OF_STAR_SPRITES))
}

create-starfield() {
  export STAR_FIELD_ANIM_SPEED=0
  export STAR_FIELD=()
  export STAR_CHARS=("·" "•" "+")
  export STAR_COLORS=("$WHT" "$wht" "$blk")
  export STAR_SPRITES=()
  export NUM_OF_STAR_SPRITES=-1
  readonly STAR_MAX=$((SCREEN_HEIGHT / 4 ))
  readonly STAR_FLOOR=$((SCREEN_HEIGHT -3))
  local STAR_CHAR=""
  local STAR_COLOR=""
  local STAR_LOOP=0
  local CHAR_LOOP=0
  local COL_LOOP=0
  
  # Build array of star sprites
  for (( COL_LOOP=0; COL_LOOP < ${#STAR_COLORS[@]}; COL_LOOP++ )); do
    for (( CHAR_LOOP=0; CHAR_LOOP < ${#STAR_CHARS[@]}; CHAR_LOOP++ )); do
      ((NUM_OF_STAR_SPRITES++))
      STAR_CHAR="${STAR_CHARS[${CHAR_LOOP}]}"
      STAR_COLOR="${STAR_COLORS[${COL_LOOP}]}"
      STAR_SPRITES+=("${STAR_COLOR}${STAR_CHAR}")
    done
  done

  for (( STAR_LOOP=0; STAR_LOOP < STAR_MAX; STAR_LOOP++ )); do
    a-star-is-born 0
    STAR_FIELD+=("${NEW_STAR_X} ${NEW_STAR_Y} ${NEW_STAR_SPRITE_INDEX}")
  done
}

animate-starfield() {
  if ((STAR_FIELD_ANIM_SPEED == 0)); then
    local TOTAL_STARS=${#STAR_FIELD[@]}
    local STAR_INSTANCE=()
    local STAR_X=0
    local STAR_Y=0
    local STAR_SPRITE_INDEX=0
    local STAR_SPRITE=()
    local STAR_LOOP=0

    if ((TOTAL_STARS < STAR_MAX)); then
      # Birth a new star
      a-star-is-born 1
      STAR_FIELD+=("${NEW_STAR_X} ${NEW_STAR_Y} ${NEW_STAR_SPRITE_INDEX}")
      ((TOTAL_STARS++))
    fi

    for (( STAR_LOOP=0; STAR_LOOP < TOTAL_STARS; STAR_LOOP++ )); do
      STAR_INSTANCE=(${STAR_FIELD[${STAR_LOOP}]})
      STAR_X=${STAR_INSTANCE[0]}
      STAR_Y=${STAR_INSTANCE[1]}
      STAR_SPRITE_INDEX=${STAR_INSTANCE[2]}
      STAR_SPRITE=(
        "${SPC} "
        "${STAR_SPRITES[${STAR_SPRITE_INDEX}]}"
        )
      if ((STAR_Y >= STAR_FLOOR)); then
        # Remove the dead star
        erase-sprite 0 "${STAR_X}" "${STAR_Y}" "${STAR_SPRITE[@]}"
        unset STAR_FIELD[${STAR_LOOP}]
        STAR_FIELD=("${STAR_FIELD[@]}")
        ((TOTAL_STARS--))
        continue
      else
        ((STAR_Y++))
        STAR_FIELD[${STAR_LOOP}]="${STAR_X} ${STAR_Y} ${STAR_SPRITE_INDEX}"
      fi
      draw-sprite 0 "${STAR_X}" "${STAR_Y}" "${STAR_SPRITE[@]}"
    done
  fi
  # Increment the star field animation speed control
  ((STAR_FIELD_ANIM_SPEED > 5)) && STAR_FIELD_ANIM_SPEED=0 || ((STAR_FIELD_ANIM_SPEED++))
}