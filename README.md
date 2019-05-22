# ANSI Alien Attack!

A game, written in Bash, that is a somewhat retro-a-like shoot 'em up. Hopefully.

## Plans

  - [x] Tick
    - [x] Hardware interrupt trap to govern the game loop via a subshell.
  - [x] Input handler
    - [x] Keyboard
    - [x] Xbox360 Controller
  - [ ] Graphics
    - [x] ANSI sprite engine
    - [ ] Sprite overlays
    - [x] Framebuffer
    - [x] Sprite collision detection
    - [x] Starfield
    - [ ] Random twinkling stars
    - [ ] Parallax scrolling
    - [x] Performance metrics
  - [x] Audio
    - [x] Sound effects engine
    - [x] Music engine
    - [x] Disable audio for remote connections
  - [x] Title screen engine
    - [ ] Main screen artwork
    - [ ] Game over artwork
    - [ ] Victory artwork
  - [ ] Enemies
    - [x] Fighters
    - [x] Fighter AI
    - [ ] Gun turrets
    - [ ] Gun turret AI
    - [ ] Boss ships
    - [ ] Boss ship AI
  - [ ] Power ups
    - [x] Bonus points
    - [ ] Weapon upgrades
    - [ ] Shields
    - [ ] Smartbomb
  - [ ] Animators
    - [x] Player thrust
    - [ ] Player roll
    - [ ] Impact animations
    - [ ] Explosion animations
  - [ ] Level progression
    - [x] Number of enemies rises
    - [x] Enemy firepower increases
    - [x] Enemy speed increases
    - [ ] Canyon levels, narrow playable area
    - [ ] Level progression animations
  - [ ] 2P
    - [ ] Local
    - [ ] Network
  - [ ] Title screen attract mode
    - [ ] Highscores
    - [ ] Configuration
    - [ ] Credits
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

The title graphics are made with <http://patorjk.com/software/taag/> and `lolcat`.

  * Create the ASCII text using <http://patorjk.com/software/taag/>
  * Save it as a .txt in `gfx/`.
  * Create the ANSI art version using `lolcat -f -F 0.2 gfx/title.txt | sed 's/\[0m/\[30m/g' > gfx/title.ans`
    * The `sed` replaces black with transparent.

Create a preview of all the `toilet` font styles.

```
for FONT in /usr/share/figlet/*.tlf; do echo $(basename $FONT) && toilet -t -f $(basename $FONT) --filter border "Bash'em Up!" | lolcat -f -F 0.2; done
```

```
toilet -t -f ascii9 --filter border "Game Title!" | lolcat -f -F 0.2  | sed 's/\[0m/\[30m/g' > gfx/title.ans
toilet -t -f ascii9 --filter border "Game Over!" | lolcat -f -F 0.2  | sed 's/\[0m/\[30m/g' > gfx/gameover.ans
toilet -t -f ascii9 --filter border "Victory!" | lolcat -f -F 0.2  | sed 's/\[0m/\[30m/g' > gfx/victory.ans
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