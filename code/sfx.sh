#!/usr/bin/env bash

playSound=

sound-setup() {
  if command -v mpg123; then
    playSound='sound-mpg123'
  else
    playSound='sound-beep'
  fi
}

sound-teardown() {
  true
}

sound() {
  local sound=sfx/$1.mp3
  $playSound "$sound"
}

sound-mpg123() {
  mpg123 -q "$*" > /dev/null 2>&1 &
}

sound-beep() {
  echo -en '\a' &
}