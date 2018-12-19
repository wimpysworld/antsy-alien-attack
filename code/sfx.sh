#!/usr/bin/env bash

SOUND_BACKEND=

sound-setup() {
  # Is this connection remote?
  if [ -n "${SSH_CLIENT}" ] || [ -n "${SSH_TTY}" ]; then
    MUSIC_BACKEND='sound-silence'
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
  local SOUND=sfx/$1.mp3
  ${SOUND_BACKEND} "${SOUND}"
}

sound-mpg123() {
  mpg123 -q "$*" > /dev/null 2>&1 &
}

sound-beep() {
  echo -en '\a' &
}

sound-silence() {
  :
}