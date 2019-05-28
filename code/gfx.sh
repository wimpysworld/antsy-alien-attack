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
  if ((SECONDS > SEC)); then
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
  ((FPS_ENABLED)) && fps-counter
  echo -en "${FRAME_BUFFER}"
  unset FRAME_BUFFER
}

blank-screen() {
  local Y=0
  local STR=$(repeat " " "${SCREEN_WIDTH}")
  for ((Y=0; Y < SCREEN_HEIGHT; Y++)); do
    draw 0 "${Y}" "${SPC}${STR}"
  done
}

draw() {
  local X=$((${1} + 1))
  local Y=$((${2} + 1))
  local COLOR=${3}
  local STR=${*:4}
  FRAME_BUFFER+="\e[${Y};${X}H\e[$COLOR${STR}\e[m"
}

raw-draw() {
  local X=$((${1} + 1))
  local Y=$((${2} + 1))
  local STR=${3}
  FRAME_BUFFER+="\e[${Y};${X}H${STR}"
}

lol-draw() {
  local X=${1}
  local Y=${2}
  local STR=$(echo "${3}" | lolcat -f -F 0.2)
  FRAME_BUFFER+="\e[${Y};${X}H${STR}"
}

draw-centered() {
  local Y=${1}
  local COLOR=${2}
  local STR=${*:3}
  local OFFSET=$(center ${#STR})
  draw "${OFFSET}" "${Y}" "${COLOR}" "${STR}"
}

raw-draw-centered() {
  local Y=${1}
  local STR=${*:2}
  local OFFSET=$(center ${#STR})
  raw-draw "${OFFSET}" "${Y}" "${STR}"
}

lol-draw-centered() {
  local Y=${1}
  local STR="${2}"
  local OFFSET=$(center ${#STR})
  lol-draw "${OFFSET}" "${Y}" "${STR}"
}

draw-right() {
  local Y=${1}
  local COLOR=${2}
  local STR=${*:3}
  local OFFSET=$((SCREEN_WIDTH - ${#STR}))
  draw "${OFFSET}" "${Y}" "${COLOR}" "${STR}"
}

raw-draw-right() {
  local Y=${1}
  local STR=${*:2}
  local OFFSET=$((SCREEN_WIDTH - ${#STR}))
  raw-draw "${OFFSET}" "${Y}" "${STR}"
}

lol-draw-right() {
  local Y=${1}
  local STR=${2}
  local OFFSET=$((SCREEN_WIDTH - ${#STR}))
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
    X=$((OFFSET + SIN[${i}]))
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
  local LOOP=0
  local CONTENT=()
  readarray -t CONTENT < "${FILENAME}"
  for LOOP in "${!CONTENT[@]}"; do
    raw-draw "${X}" "$((Y + LOOP))" "${CONTENT[${LOOP}]}"
  done
}

draw-picture-centered() {
  local FILENAME="${1}"
  local HEIGHT=$(wc -l gfx/${FILENAME}.txt | cut -d' ' -f1)
  local WIDTH=$(wc -L gfx/${FILENAME}.txt | cut -d' ' -f1)
  local Y_OFFSET=$(( (SCREEN_HEIGHT / 2) - (HEIGHT / 2) ))
  local X_OFFSET=$(center ${WIDTH})
  draw-picture "${X_OFFSET}" "${Y_OFFSET}" "${FILENAME}"
}

draw-sprite-unmasked() {
  local X=${1}; shift
  local Y=${1}; shift
  local SPRITE=("$@")
  local LOOP=0
  for LOOP in "${!SPRITE[@]}"; do
      raw-draw "${X}" "$((Y + LOOP))" "${SPRITE[${LOOP}]}"
  done
}

draw-sprite-masked() {
  local X=${1}; shift
  local Y=${1}; shift
  local SPRITE=("$@")
  local LOOP=0
  for LOOP in "${!SPRITE[@]}"; do
      raw-draw "${X}" "$((Y + LOOP))" "$SPC ${SPRITE[${LOOP}]}$SPC "
  done
}

erase-sprite-unmasked() {
  local X=${1}; shift
  local Y=${1}; shift
  local SPRITE=("$@")
  local LOOP=0
  local ERASE=$(repeat " " "${#SPRITE[0]}")
  for LOOP in "${!SPRITE[@]}"; do
    raw-draw "${X}" "$((Y + LOOP))" "${SPC}${ERASE}"
  done
}

erase-sprite-masked() {
  local X=${1}; shift
  local Y=${1}; shift
  local SPRITE=("$@")
  local LOOP=0
  local ERASE=$(repeat " " "${#SPRITE[0]}")
  for LOOP in "${!SPRITE[@]}"; do
    raw-draw "${X}" "$((Y + LOOP))" "$SPC ${ERASE}$SPC "
  done
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
  NEW_STAR_TYPE=$((RANDOM % NUM_OF_STAR_SPRITES))
}

create-starfield() {
  export STAR_FIELD=()
  export STAR_SPRITES=()
  export NUM_OF_STAR_SPRITES=8
  readonly STAR_MAX=$((SCREEN_HEIGHT / 4 ))
  readonly STAR_FLOOR=$((SCREEN_HEIGHT -3))
  local STAR_LOOP=0

  for (( STAR_LOOP=0; STAR_LOOP < STAR_MAX; STAR_LOOP++ )); do
    a-star-is-born 0
    STAR_FIELD+=("${NEW_STAR_X} ${NEW_STAR_Y} ${NEW_STAR_TYPE}")
  done
}

animate-starfield() {
  if ((ANIMATION_KEYFRAME % 8 == 0)); then
    local TOTAL_STARS=${#STAR_FIELD[@]}
    local STAR_INSTANCE=()
    local STAR_X=0
    local STAR_Y=0
    local STAR_TYPE=0
    local STAR_SPRITE=()
    local STAR_LOOP=0

    if ((TOTAL_STARS < STAR_MAX)); then
      # Birth a new star
      a-star-is-born 1
      STAR_FIELD+=("${NEW_STAR_X} ${NEW_STAR_Y} ${NEW_STAR_TYPE}")
      ((TOTAL_STARS++))
    fi

    for (( STAR_LOOP=0; STAR_LOOP < TOTAL_STARS; STAR_LOOP++ )); do
      STAR_INSTANCE=(${STAR_FIELD[${STAR_LOOP}]})
      STAR_X=${STAR_INSTANCE[0]}
      STAR_Y=${STAR_INSTANCE[1]}
      STAR_TYPE=${STAR_INSTANCE[2]}
      case ${STAR_TYPE} in
        0) STAR_SPRITE=("${STAR_0[@]}");;
        1) STAR_SPRITE=("${STAR_1[@]}");;
        2) STAR_SPRITE=("${STAR_2[@]}");;
        3) STAR_SPRITE=("${STAR_3[@]}");;
        4) STAR_SPRITE=("${STAR_4[@]}");;
        5) STAR_SPRITE=("${STAR_5[@]}");;
        6) STAR_SPRITE=("${STAR_6[@]}");;
        7) STAR_SPRITE=("${STAR_7[@]}");;
        8) STAR_SPRITE=("${STAR_8[@]}");;
      esac

      if ((STAR_Y >= STAR_FLOOR)); then
        # Remove the dead star
        erase-sprite-unmasked "${STAR_X}" "${STAR_Y}" "${STAR_SPRITE[@]}"
        unset STAR_FIELD[${STAR_LOOP}]
        STAR_FIELD=("${STAR_FIELD[@]}")
        ((TOTAL_STARS--))
        continue
      else
        ((STAR_Y++))
        STAR_FIELD[${STAR_LOOP}]="${STAR_X} ${STAR_Y} ${STAR_TYPE}"
        draw-sprite-unmasked "${STAR_X}" "${STAR_Y}" "${STAR_SPRITE[@]}"
      fi
    done
  fi

}

reset-gfx-timers() {
  export ANIMATION_KEYFRAME=0
}

update-gfx-timers() {
  # Increment the animation keyframe counter
  ((ANIMATION_KEYFRAME > 60)) && ANIMATION_KEYFRAME=0 || ((ANIMATION_KEYFRAME++))
}