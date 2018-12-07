# Bash 'em Up!

A game, written in Bash, that is a somewhat retro-a-like shoot 'em up. Hopefully.

## Requirements

  - `kill`
  - `lolcat`
  - `mpg123`
  - `ogg123`
  - `pkill`

The following will get you want you need on Ubuntu.

    sudo apt install lolcat mpg123 procps vorbis-tools 

## Title Screen

The title graphics are made with `toilet` and `lolcat`.

Create a preview of all the font styles.

```
for FONT in /usr/share/figlet/*.tlf; do echo $(basename $FONT) && toilet -t -f $(basename $FONT) --filter border "Bash'em Up!" | lolcat -f -F 0.2; done
```

I settled on `ascii9` for the main title graphic.

```
toilet -t -f ascii9 --filter border "Bash'em Up!" | lolcat -f -F 0.2 > gfx/title.ans
toilet -t -f ascii9 --filter border "Game Over!" | lolcat -f -F 0.2 > gfx/gameover.ans
toilet -t -f ascii9 --filter border "Victory!" | lolcat -f -F 0.2 > gfx/victory.ans
```

## References

  * http://xion.io/post/code/bash-flappy-bird.html
  * https://unix.stackexchange.com/questions/350132/using-a-shell-script-with-jstest-how-can-i-get-a-gamepad-to-interact-with-my-sc
  * http://bruxy.regnet.cz/web/linux/EN/housenka-bash-game/
  * https://www.vidarholen.net/contents/blog/?p=370 <- FRAMEBUFFER tput!
  * https://www.root.cz/clanky/historie-vyvoje-pocitacovych-her-59-cast-hry-pro-ibm-pc-pracujici-v-textovem-rezimu/
  * http://wp.subnetzero.org/?p=269
  * https://github.com/vaniacer/piu-piu-SH
    * https://habr.com/post/335960/
      * https://translate.google.com/translate?hl=en&sl=auto&tl=en&u=https%3A%2F%2Fhabr.com%2Fpost%2F335960%2F
    * https://habr.com/post/337896/
      * https://translate.google.com/translate?hl=en&sl=auto&tl=en&u=https%3A%2F%2Fhabr.com%2Fpost%2F337896%2F
  * https://github.com/zenoamaro/arkanoid.sh
  * https://www.gnu.org/software/termutils/manual/termutils-2.0/html_chapter/tput_1.html

### Game Assets

  * https://opengameart.org
  * https://patrickdearteaga.com
    * Chiptronical           - `title.ogg`
    * Intergalactic Odyssey  - `level1.ogg`
    * Interstellar Odyssey   - `level2.ogg`
    * Interplanetary Odyssey - `level3.ogg`
    * Ruined Planet          - `gameover.ogg`
    * Friends                - `victory.ogg`