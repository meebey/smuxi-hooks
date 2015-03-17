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
    print (u"ProtocolManager.Command /echo you need to install python-dbus")
    raise SystemExit(1)

class Midori(object):

    def __init__(self):

        session_bus = dbus.SessionBus()
        try:
            player = session_bus.get_object('org.midori.mediaHerald','/org/midori/mediaHerald')
            self.__iface = dbus.Interface(player, dbus_interface='org.freedesktop.DBus.Properties')
            self.__get_iface = True
        except dbus.exceptions.DBusException:
            print (u"ProtocolManager.Command /echo you need to run midori extension 'Webmedia now-playing'")
            self.__get_iface = False
            

    @classmethod
    def GetTrackInfos(cls):
        midori = Midori()
        if midori.__get_iface:
            properties = midori.__iface.GetAll('org.midori.mediaHerald')
            output =  properties.get("VideoTitle")[1:] + ' - '+ properties.get("VideoUri")[0:]
            print(u"ProtocolManager.Command /me is playing: {}".format(output).encode("utf-8"))
            return True
        return False
