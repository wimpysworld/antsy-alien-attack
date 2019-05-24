#!/usr/bin/env bash

export GAME_TITLE="Antsy Alien Attack!"
export FPS_ENABLED=1
export MUSIC_ENABLED=1
export SFX_ENABLED=1
export HI_SCORE=1000

cfg-load(){
  if [ -e ${HOME}/.antsy-alien-attack ]; then
    source ${HOME}/.antsy-alien-attack
  fi
}

cfg-save(){
  cat << END_CFG > ${HOME}/.antsy-alien-attack
FPS_ENABLED=${FPS_ENABLED}
MUSIC_ENABLED=${MUSIC_ENABLED}
SFX_ENABLED=${SFX_ENABLED}
HI_SCORE=${HI_SCORE}
END_CFG
}