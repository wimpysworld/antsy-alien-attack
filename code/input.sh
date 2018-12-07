#!/usr/bin/env bash

KEY='\0'

start-input-handler() {
  while :; do
    read -rsn1 KEY 2>/dev/null || true
    #if [[ -z $KEY ]]; then KEY=' '; fi
  done
}