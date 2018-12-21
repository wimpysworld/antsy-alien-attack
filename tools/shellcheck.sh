#!/usr/bin/env bash

shellcheck -e SC2206 -e SC2015 -s bash *.sh cfg/*.sh code/*.sh gfx/*.sh
