#!/usr/bin/env bash

export GAME_TITLE="ANSI Alien Attack!"
export FPS_ENABLED=1
export MUSIC_ENABLED=1
export SFX_ENABLED=1
export HI_SCORE=1000

cfg-load(){
  if [ -e ${HOME}/.ansi-alien-attack ]; then
    source ${HOME}/.ansi-alien-attack
  fi
}

cfg-save(){
  cat << END_CFG > ${HOME}/.ansi-alien-attack
FPS_ENABLED=${FPS_ENABLED}
MUSIC_ENABLED=${MUSIC_ENABLED}
SFX_ENABLED=${SFX_ENABLED}
HI_SCORE=${HI_SCORE}
END_CFG
}