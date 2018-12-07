#!/usr/bin/env bash

playMusic=

music-setup() {
  if which ogg123; then
    playMusic='music-ogg123'
  else
    playMusic='music-silence'
  fi
}

music-teardown() {
  true
}

music() {
  local music=music/$1.ogg
  $playMusic "$music"
}

music-ogg123() {
  ogg123 -q -r "$*" &
}

music-silence() {
  true
}