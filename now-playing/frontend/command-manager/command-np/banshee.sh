#!/bin/sh
#
#        DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (c) 2013 Mirco Bauer <meebey@meebey.net>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

eval $(dbus-send --session --print-reply --dest=org.bansheeproject.Banshee /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | awk '
  /string  *"xesam:artist/{
    while (1) {
      getline line
      if (line ~ /string "/){
        sub(/.*string /, "ARTIST=", line)
        print line
        break
      }
    }
  }
  /string  *"xesam:title/{
    while (1) {
      getline line
      if (line ~ /string "/){
        sub(/.*string /, "TITLE=", line)
        print line
        break
      }
    }
  }
')

echo "ProtocolManager.Command /me is now playing: $ARTIST - $TITLE"
