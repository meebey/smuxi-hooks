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

QUERY_MPRIS2=0
DBUS_DESTS=
if [ ! -z "$(pgrep -u $USER --exact banshee)" ]; then
    QUERY_MPRIS2=1
    DBUS_DESTS="org.bansheeproject.Banshee"
fi
if [ ! -z "$(pgrep -u $USER --exact vlc)" ]; then
    QUERY_MPRIS2=1
    DBUS_DESTS="$DBUS_DESTS org.mpris.MediaPlayer2.vlc"
fi
if [ ! -z "$(pgrep -u $USER -x tomahawk)" ]; then
    QUERY_MPRIS2=1
    DBUS_DESTS="$DBUS_DESTS org.mpris.MediaPlayer2.tomahawk"
fi
if [ ! -z "$(pgrep -u $USER -x amarok)" ]; then
    QUERY_MPRIS2=1
    DBUS_DESTS="$DBUS_DESTS org.mpris.MediaPlayer2.amarok"
fi
if [ ! -z "$(pgrep -u $USER -x rhythmbox)" ]; then
    QUERY_MPRIS2=1
    DBUS_DESTS="$DBUS_DESTS org.mpris.MediaPlayer2.rhythmbox"
fi
if [ ! -z "$(pgrep -u $USER -x clementine)" ]; then
    QUERY_MPRIS2=1
    DBUS_DESTS="$DBUS_DESTS org.mpris.clementine"
fi

STATUS=
if [ $QUERY_MPRIS2 = 1 ]; then
    for DBUS_DEST in $DBUS_DESTS; do
        STATUS=$(dbus-send --session --print-reply --dest=$DBUS_DEST /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:PlaybackStatus | egrep 'string "(.*)"' | cut -d '"' -f 2)
        if [ "$STATUS" = "Playing" ]; then
            break
        fi
    done
fi

if [ $QUERY_MPRIS2 = 1 ]  && [ $STATUS = "Playing" ]; then
    eval $(dbus-send --session --print-reply --dest=$DBUS_DEST /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | awk '
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
elif [ ! -z "$(pgrep -u $USER --exact chrome)" ] || [ ! -z "$(pgrep -u $USER --exact chromium)" ]; then
    if [ ! -z "$(ps $(pgrep -u $USER --exact chrome | head -1) | egrep -z chromium )" ] || [ ! -z "$(pgrep -u $USER --exact chromium)" ];
    then
    	TITLE=$(strings -e l $HOME/.config/chromium/Default/Current\ Session | grep " - YouTube" | tail -n 1)
    else 
    	TITLE=$(strings -e l $HOME/.config/google-chrome/Default/Current\ Session | grep " - YouTube" | tail -n 1)
    fi
    
    if [ ! -z "$TITLE" ]; then
        TITLE=${TITLE% - YouTube}
        TITLE="$TITLE [YouTube]"
    fi
fi

if [ -z "$ARTIST" ] && [ -z "$TITLE" ]; then
    exit 0
fi

if [ -z "$ARTIST" ]; then
    echo "ProtocolManager.Command /me is now playing: $TITLE"
    exit 0
fi

if [ -z "$TITLE" ]; then
    exit 0
fi

echo "ProtocolManager.Command /me is now playing: $ARTIST - $TITLE"
