#!/usr/bin/env bash

MUSIC_BACKEND=

music-setup() {
  # Is this connection remote?
  if [ -n "${SSH_CLIENT}" ] || [ -n "${SSH_TTY}" ]; then
    MUSIC_BACKEND='music-silence'
  elif command -v ogg123 > /dev/null 2>&1; then
    MUSIC_BACKEND='music-ogg123'
  else
    MUSIC_BACKEND='music-silence'
  fi
}

music-teardown() {
  pkill -u "${USER}" ogg123 > /dev/null 2>&1
}

music() {
  local MUSIC=music/$1.ogg
  ${MUSIC_BACKEND} "${MUSIC}"
}

music-ogg123() {
  ogg123 -q -r "${1}" > /dev/null 2>&1 &
}

music-silence() {
  :
}