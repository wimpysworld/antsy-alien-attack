# Antsy Alien Attack!

A game, written in Bash, that is a somewhat retro-a-like shoot 'em up. Hopefully.

## Plans

  - [x] Tick
    - [x] Hardware interrupt trap to govern the game loop via a subshell.
  - [x] Input handler
    - [x] Keyboard
    - [x] Xbox360 Controller
  - [ ] Graphics
    - [x] Framebuffer
    - [x] Sprite engine
    - [x] Sprite collision detection
    - [ ] Sprite overlays
    - [x] Starfield
    - [x] Performance metrics
  - [ ] Animators
    - [x] Player thrust
    - [ ] Player roll
    - [x] Explosion animations
  - [x] Audio
    - [x] Sound effects engine
    - [x] Music engine
    - [x] Disable audio for remote connections
  - [x] Title screen engine
    - [x] Main screen artwork
    - [x] Game over artwork
    - [x] Victory artwork
  - [ ] Enemies
    - [x] Fighters
    - [x] Hunter Fighter AI
    - [ ] Sniper Fighter AI
    - [ ] Boss ships
    - [ ] Boss ship AI
  - [x] Power ups
    - [x] Bonus points
    - [x] Weapon upgrades
    - [x] Shields
    - [x] Smartbomb
    - [x] Extra life
  - [ ] Level progression
    - [x] Number of enemies rises
    - [x] Enemy firepower increases
    - [x] Enemy speed increases
    - [x] Bonus spawn rate decreases
    - [x] Bonus value increases
    - [ ] Canyon levels, narrow playable area
    - [x] Level progression announcements
    - [x] Level-up skill points
  - [ ] 2P
    - [x] Local
    - [ ] Network
  - [x] Title screen attract mode
    - [x] High score
    - [x] Configuration
    - [x] Credits
  - [ ] Snap
    - [ ] Bundle alacritty and fonts
    - [ ] Desktop Launcher

## Requirements

  - `coreutils` for `stty`
  - [`joy2key`](https://sourceforge.net/projects/joy2key/)
  - `lolcat`
  - `mpg123`
  - `ncurses-bin` for `tput`
  - `vorbis-tools` for `ogg123`
  - `procps` for `kill`, `pkill`
  - `xterm` for `resize`

The following will get you want you need on Ubuntu.

    sudo apt install lolcat mpg123 ncurses-bin procps vorbis-tools

### Compile joy2key

```
sudo apt install libx11-dev x11-utils
wget -c http://sourceforge.net/projects/joy2key/files/joy2key/1.6.3/joy2key-1.6.3.tar.bz2
wget -c http://sourceforge.net/p/joy2key/patches/_discuss/thread/e73f20a1/33d7/attachment/button_list_segfault.patch
tar xvf joy2key-1.6.3.tar.bz2
patch -p0 -i ../button_list_segfault.patch
cd joy2key-1.6.3
./configure --prefix=/usr/local
make
sudo make install
```

### Xbox 360

#### AXIS

  * 0 = left analog stick X-axis
  * 1 = left analog stick Y-axis
  * 2 = left trigger
  * 3 = right analog stick X-axis
  * 4 = right analog stick Y-axis
  * 5 = right trigger
  * 6 = hat (d-pad) X-axis
  * 7 = hat (d-pad) Y-axis

#### Buttons

  * 0 = A
  * 1 = B
  * 2 = X
  * 3 = Y
  * 5 = left shoulder
  * 6 = right shoulder

## Title Screen

The title graphics are using `toilet` and `lolcat` via [tools/render-titles.sh](tools/render-titles.sh).
You can preview of all the `toilet` font styles using this:

```
for FONT in /usr/share/figlet/*.tlf; do echo $(basename $FONT) && toilet -t -f $(basename $FONT) --filter border "Antsy Alien Attack!" | lolcat -f -F 0.2; done
```

## References

### Bash

  * https://devhints.io/bash
  * Subshells
    - [subshell Explained](https://unix.stackexchange.com/questions/138463/do-parentheses-really-put-the-command-in-a-subshell?answertab=votes#tab-top)

### Applications

  * https://www.gnu.org/software/termutils/manual/termutils-2.0/html_chapter/tput_1.html
  * https://ubuntuforums.org/showthread.php?t=646564

### Game Assets

  * https://opengameart.org

#### Music

  * [Patrick de Arteaga](https://patrickdearteaga.com)
    * Chiptronical           - `title.ogg`
    * Intergalactic Odyssey  - `level1.ogg`
    * Interstellar Odyssey   - `level2.ogg`
    * Interplanetary Odyssey - `level3.ogg`
    * Ruined Planet          - `gameover.ogg`
    * Friends                - `victory.ogg`

#### Sound effects

  * [Kenney Vleugels](http://www.kenney.nl)
    * `laser.mp3`
    * `game-over.mp3`
    * `congratulations.mp3`
    * `bonus-points.mp3`
  * Viktor Hahn
    * `fighter-explosion.mp3`

### Fonts

#### Terminal fonts

  * https://int10h.org/oldschool-pc-fonts/
  * http://www.fixedsysexcelsior.com/
  * https://github.com/ansilove/BlockZone

### ANSI & ASCII

  * https://shiroyasha.svbtle.com/escape-sequences-a-quick-guide-1

#### Editors

  * http://bruxy.regnet.cz/web/linux/EN/ansi-art-sh-paint/
  * http://www.syaross.org/thedraw/
  * http://picoe.ca/products/pablodraw/
  * http://tetradraw.sourceforge.net/
  * https://sourceforge.net/projects/tundradraw/
  * https://sourceforge.net/projects/mysticdraw/
  * http://syncdraw.bbsdev.net/
  * https://www.gridsagegames.com/rexpaint/index.html

#### Fonts

  * http://patorjk.com/blog/2014/01/22/thedraws-lost-ansi-art-fonts/
    * http://patorjk.com/software/taag
  * https://www.roysac.com/thedrawfonts-tdf.html

#### Artwork

  * [Code page 437)](https://en.wikipedia.org/wiki/Code_page_437)
  * [ASCII table , ascii codes](https://theasciicode.com.ar/)
  * https://textart.io/
  * https://asciiart.website/
  * http://ascii.co.uk/
  * http://www.ascii-art.de/
  * http://asciiartist.com/
  * http://www.asciiworld.com/
  * https://www.asciiart.eu
  * https://text-symbols.com
  * https://www.ansilove.org/
  * https://asciiart.club/
  * https://16colo.rs

## Learnings

  * `case` is twice as fast as `if`, `elif`, `else`, `fi`.
  * `echo -e` is fast than `tput` and `tput` is faster that `printf`.
  * Arithmetic comparison are faster than tests
    * For example `if ((HUNT_P1 == 1)); then` is faster than `if [ ${HUNT_P1} -eq 1]; then`
  * Bash has C style loops
    * Like this `for (( FIGHTER_LOOP=0; FIGHTER_LOOP < TOTAL_FIGHTERS; FIGHTER_LOOP++ )); do`
  * I never knew about `((TOTAL_STARS++))` or `((TOTAL_STARS+=5))` or `((TOTAL_STARS+=MORE_STARS))`
  * Px437 IBM VGA Regular at 16px is best font.