#!/usr/bin/env bash

readonly SCREEN_WIDTH=$(tput cols)
readonly SCREEN_HEIGHT=$(tput lines)
readonly ORIGINAL_TTY=$(stty -g)

framebuffer=
frame=0

gfx-setup() {
  stty raw -echo
  tput civis
  tput rmam
  printf "\e]0;Bash 'em Up!\007"
}

gfx-teardown() {
  stty "$ORIGINAL_TTY"
  tput cvvis
  tput smam
  tput sgr0
  tput clear
  echo -en "\e[0m"
}

render() {
  echo -en "${framebuffer}"
  framebuffer=
  ((frame++))
}

draw() {
  local x=$1
  local y=$2
  local color=$3
  local str=${*:4}
  framebuffer="${framebuffer}\e[$((y+1));$((x+1))H\e[$((color+90));m${str}\e[m"
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

lol-draw-right() {
  local y=$1
  local str=${3}
  local offset=$((SCREEN_WIDTH - ${#str}))
  lol-draw "$offset" "$y" "$str"
}

draw-picture() {
  local x=$1
  local y=$2
  local filename=gfx/$3.ans
  local contents=()
  local offset=0
  readarray -t contents < "$filename"
  for line in "${contents[@]}"; do
    draw "$x" "$((y+offset))" 0 "$line"
    ((offset++))
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