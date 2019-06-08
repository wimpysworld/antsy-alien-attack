#!/usr/bin/env bash

if [ $(id -u) -ne 0 ]; then
  echo "ERROR! The script need to be run as root."
  exit 1
fi

apt -y install coreutils lolcat mpg123 ncurses-bin procps vorbis-tools
wget -c https://int10h.org/oldschool-pc-fonts/download/ultimate_oldschool_pc_font_pack_v1.0.zip -O /tmp/ultimate_oldschool_pc_font_pack_v1.0.zip
cd /tmp
unzip -o ultimate_oldschool_pc_font_pack_v1.0.zip
mkdir -p /usr/share/fonts/truetype
mv Px* /usr/share/fonts/truetype
fc-cache -fv
rm -rfv /tmp/Bm*
rm -rfv /tmp/Px*
rm -v /tmp/ultimate_oldschool_pc_font_pack_v1.0.zip
