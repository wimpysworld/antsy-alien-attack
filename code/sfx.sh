#!/usr/bin/env bash

SOUND_BACKEND=

sound-setup() {
  # Is this connection remote?
  if [ -n "${SSH_CLIENT}" ] || [ -n "${SSH_TTY}" ]; then
    SOUND_BACKEND='sound-silence'
  elif ((SFX_ENABLED == 0)); then
    SOUND_BACKEND='sound-silence'
  elif command -v mpg123 > /dev/null 2>&1; then
    SOUND_BACKEND='sound-mpg123'
  else
    SOUND_BACKEND='sound-beep'
  fi
}

sound-teardown() {
  true
}

sound() {
  local SOUND=
  local SOUNDS=""
  for SOUND in "$@"; do
    MP3="sfx/$SOUND.mp3 "    
    SOUNDS+="$MP3"
  done
  ${SOUND_BACKEND} "${SOUNDS}"
}

sound-mpg123() {
  mpg123 -q ${1} > /dev/null 2>&1 &
}

sound-beep() {
  echo -en '\a' &
}

sound-silence() {
  :
}