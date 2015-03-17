#-*- coding: utf-8 -*-
#
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# Version 2, December 2004
#
# Copyright (c) 2015 James Axl <axlrose112@gmail.com>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.

try:
    import dbus
except ImportError:
    print (u"ProtocolManager.Command /echo you need to install python-dbus")
    raise SystemExit(1)

class MprisPlayer(object):

    def __init__(self, mplayer):
        session_bus = dbus.SessionBus()
        player = session_bus.get_object('org.mpris.MediaPlayer2.%s' %mplayer, '/org/mpris/MediaPlayer2')
        self.__iface = dbus.Interface(player, dbus_interface='org.freedesktop.DBus.Properties')

    def GetTrackInfos(self):
        try:
            artist = self.__iface.Get('org.mpris.MediaPlayer2.Player','Metadata').get(dbus.String(u'xesam:artist'))[0]
            if artist == None: artist = 'Unknown'
        except TypeError:
            artist = 'Unknown'

        try:
            title = self.__iface.Get('org.mpris.MediaPlayer2.Player','Metadata').get(dbus.String(u'xesam:title'))
            if title == None: title = 'Unknown'
        except TypeError:
            title = 'Unknown'

        output = artist + ' - '+ title
        print(u"ProtocolManager.Command /me is playing: {}".format(output).encode("utf-8"))

    def GetStatus(self):
        player_stat = self.__iface.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')
        if player_stat == 'Playing':
            return True
        return False

       
