# Bash 'em Up!

A game, written in Bash, that is a somewhat retro-a-like shoot 'em up. Hopefully.

## Requirements

  - `kill`
  - `mpg123`
  - `ogg123`
  - `pkill`

The folloing will get you want you need on Ubuntu.

    sudo apt install mpg123 procps vorbis-tools 

## Title Screen

Made with `toilet` and `ponysay`.

```
toilet -t -f ascii12.tlf --filter border "Bash 'em Up!" | lolcat -f > ~/snap/ponysay/title.ans
ponysay --ponyonly --pony philomenaphoenix >> ~/snap/ponysay/title.ans
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
    * Chiptronical           - title.ogg
    * Intergalactic Odyssey  - level1.ogg
    * Interstellar Odyssey   - level2.ogg
    * Interplanetary Odyssey - level3.ogg
    * Ruined Planet          - gameover.ogg
    * Friends                - credits.ogg


