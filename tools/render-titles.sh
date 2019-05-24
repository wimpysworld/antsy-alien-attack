#!/usr/bin/env bash

toilet -t -f pagga --filter border "               ANSI              " > gfx/title.txt
toilet -t -f smmono12 --filter border " Alien Attack! " >> gfx/title.txt

toilet -t -f pagga --filter border "       YOU LOSE       " > gfx/gameover.txt
toilet -t -f smmono12 --filter border " GAME OVER! " >> gfx/gameover.txt

toilet -t -f pagga --filter border "      YOU WIN      " > gfx/victory.txt
toilet -t -f smmono12 --filter border " VICTORY! " >> gfx/victory.txt

for TEXT in gfx/*.txt; do
    ANSI=$(echo ${TEXT} | sed 's/txt/ans/')
    echo "Rendering ${TEXT} to ${ANSI}"
    lolcat -f -F 0.2 "${TEXT}" | sed 's/\[0m/\[30m/g' > "${ANSI}"
    cat "${ANSI}"
done