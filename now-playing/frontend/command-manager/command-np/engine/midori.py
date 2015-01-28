#! /usr/bin/env python
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

import sys

try:
    import dbus
except ImportError:
    print (u"ProtocolManager.Command /echo you need to install python-dbus :)")
    sys.exit()

class Midori(object):

    def __init__(self):

        session_bus = dbus.SessionBus()
        try:
            player = session_bus.get_object('org.midori.mediaHerald','/org/midori/mediaHerald')
            self.__iface = dbus.Interface(player, dbus_interface='org.freedesktop.DBus.Properties')
        except:
            print (u"ProtocolManager.Command /echo you need to run midori extension 'Webmedia now-playing' :)")
            sys.exit()

    @classmethod
    def GetTrackInfos(cls):
        midori = Midori()
        properties = midori.__iface.GetAll('org.midori.mediaHerald')
        output =  properties.get("VideoTitle")[1:] + ' - '+ properties.get("VideoUri")[0:]
        print(u"ProtocolManager.Command /me is playing: {}".format(output).encode("utf-8"))

