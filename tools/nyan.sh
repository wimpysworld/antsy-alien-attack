#!/bin/bash
#  --------------------------------------------------------------------------
#  (c) 2012 BruXy            Version: 1.0             http://bruxy.regnet.cz/
#  --------------------------------------------------------------------------
# switch off cursor, set blue background, clear screen
echo -e "\E[?25l\E[44m\E[2J"

# Play music
M=/tmp/cat_orig.mp3
[ ! -f $M ] && wget http://nyan.cat/music/original.mp3 -O $M >/dev/null 2>&1
while true; do mplayer $M > /dev/null 2>&1; done &

# easy way to reset terminal and exit subprocesses
trap "reset;killall nyan_cat.sh" 2

## Nyan cat ANSI picture data, my own creation :P, size 38 x 11
# Compressed version of picture
D="H4sIAHUNPlAAA22Q2w7CIAyG730rC1IGEs3itoS7cYlLvFGf37YcPMQvo5DxpT+pMYLb/8OVSxNv
Aiq1Db9sSmG1TgKqdhXqktKtsyBW6F08gB/EcgAUG2eAeRxbryqi1hq89yvQgfrFZ6If8E7sVoet
aVqWlNjqgYGlA5ckG5r4EGqvHmgtGeWzlqwLc6dJHD8Sr/IMQadMiTxR0IDrN/RUUjDnLJOghYn9
UgtyzvTcNvvdCw/8WhWjAQAA"

# decompress it to $C
C=`echo "$D" | base64 -d | zcat`

# hash field with 'pixel' atributes
declare -A B

B=([A]=43\;30m▀ [a]=43\;30m▄ [B]=47\;30m▀ [b]=47\;30m▄ [C]=43m\  [D]='47m '
[E]=1\;40\;37m▀\\E[0m [F]=44m\  [G]=40m\  [H]=1\;31m█\\E[0m [I]=0\;35m█
[J]=44\;30m▄ [j]=44\;30m▀ [K]=45\;30m▄ [k]=45\;30m▀ [L]=43\;35m▀
[l]=43\;35m▄ [M]=45\;31m▄ [O]=31m█ [o]=44\;31m▄ [P]=33m█ 
[R]=42\;33m▀ [S]=42\;32m█ [s]=46\;32m▀ [T]=46\;36m█ [t]=46\;30m▄
[U]=45\;35m█ [u]=46\;35m▀ [V]=43\;30m▄ [v]=42\;30m▀ [W]=45\;30m▀
[X]=43\;32m▄ [x]=32m█ [c]=44\;36m▀ [d]=42\;35m▄ [e]=41\;33m▄ [Z]=44m\\n)

# get size of terminal window
read X Y <<< `tput cols; tput lines`

# some terminals have problem with background color change
# this fills screen with spaces and fill my signature to bottom left
printf "%*s" $[X*Y] BruXy

##################
### Draw Nyan Cat
##################

# set position to the center
xp=$[(X-37)/2]
yp=$[(Y-11)/2]

# go through image data and draw them to specified position

j=1 #row    ... y
k=1 #column ... x
for i in {0..417} #38*11-1 image size
do
    p=${C:$i:1} # get pixel
    # put pixel to given position \E[y;xH
    echo -en "\E[$[j+yp];$[k+xp]H\E[${B[$p]}"
    # if pixel Z is found go to next row (pixel count worked strange)
    k=$[k++,k%38]; [ $p = 'Z' ] && : $[j++]
done

###################
### Star animation
###################

# Field with stars animation
S=("       " "   ▄   " "       " "       "
"       " "  ▄▀▄  " "   ▀   " "       "
"   ▄   " "   ▀   " "▀▀ ▀ ▀▀" "   █   "
"   ▄   " " ▀   ▀ " "▀     ▀" " ▀ ▄ ▀ "
"   ▄   " "       " "▀     ▀" "   ▄   ")

# function for star drawing
# $1 .. column, $2 .. row position
s () {
    echo -en "\E[1;37m" # set bright white
    for j in {0..4} # for each line
    do
        # draw one star frame of animation
        for i in {0..3}
        do
            echo -en "\E[$[i+$1];$[$2+m]H\E[1;37m${S[$[i+4*j]]}\E[0;44m"
        done

        sleep 0.2

        # erase star
        for i in {0..3}
        do
            echo -en "\E[$[i+$1];$[$2+m]H\E[44m${S[0]}"
        done
        : $[m-=5] # move the next frame 5 columns to the left
    done
}

# count star positions according to nyan cat position 
# -3,+3 best constant, I've played with those numbers
# to get best position of stars and do not destroy the cat :)
my=$[(Y-11)/2 - 3]
My=$[my+11 + 3]

while true
do
    for i in $(eval echo {1..$my..4}) # each position 4 rows difference
    do
        # draw top star, animation has 20 columns length, so generated
        # for lowest start position columns is 0+20
        (s $i $[20 + $RANDOM % (X - 20)]) &
        # draw bottom star 
        (s $[i+My] $[20 + $RANDOM % (X - 20)]) &
    done
    sleep 0.5
done &

######################
### Draw rainbow flag
######################

# oOPXxUuT .. top wave, OePxdUTc bottom wave
A="oOPXxUuTOePxdUTc";

# Flag waving:
# $c .. flip flop when counter $i modulo 5 is zero,
#       then it adress top or bottom wave
while true
do
    : $[c^=1]
    for x in `eval echo {1..$[xp]}`
    do
        if [ $[i++ % 5] -eq 4 ]; then : $[c^=1]; fi;
        for y in {0..7}
        do
            echo -en "\E["$[yp+y+2]";${x}H\E[${B[${A:$[y+(c*8)]:1}]}\E[0m"
        done
    done
    sleep 0.5
done
