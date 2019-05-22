#!/usr/bin/env bash

for TEXT in gfx/*.txt; do
    ANSI=$(echo ${TEXT} | sed 's/txt/ans/')
    echo "Rendering ${TEXT} to ${ANSI}"
    lolcat -f -F 0.2 "${TEXT}" | sed 's/\[0m/\[30m/g' > "${ANSI}"
done