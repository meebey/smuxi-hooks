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

import socket
import select
import re
import sys

SPACE = {
        u"b": " ", ## Space
        }

class Mpd(object):

    def __init__(self):
        ## This is used to extract arguments from format strings like "{this} and {that}"
        self.__rx_find_kwargs = re.compile(r"{([\w_]+)}")

    ## Why not just use mpc you say? Because dependencies. Also, sockets are fun.
    def __getStatus(self):
        try:
            connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            connection.connect(("localhost", 6600))
            connection.sendall(b"currentsong\r\n")
        except socket.error:
            print "ProtocolManager.Command /echo check MPD connection"
            return False
        ## Receive the header from mpd
        header = b""
        while True:
            if not select.select([connection], [], [], 0.01):
                ## Timeout
                break

            try:
                data = connection.recv(1024)
            except socket.timeout:
                ## Timeout
                break

            if data:
                header += data
            else:
                break

        ## I really don't understand why str().partition(pattern) returns (left, patter, right) instead
        ## of just returning (left, right). Anyway that's why this list comprehension got a little more complicated
        pairs = [ (x.decode("utf-8").lower(), z.decode("utf-8")) for x, y, z in [
                    line.partition(b": ") for line in header.splitlines()[1:] ] ]
        return dict(pairs)

    def __formatStatus(self, form):
        info = self.__getStatus()
        if info:
            kwargs = self.__rx_find_kwargs.findall(form)
            for arg in kwargs:
                if not info.get(arg):
                    info[arg] = "Unknown"
            ## This seemed like the simplest solution for adding colors
            ## but it does mean that when writing a new module for a new player,
            ## the programmer has to remember to add this.
            info.update(SPACE)
            return form.format(**info)
        return False

    @classmethod
    def GetTrackInfos(cls):
        mpd = Mpd()
        socket.setdefaulttimeout(0.01)
        if mpd.__formatStatus("Send"):
            print mpd.__formatStatus(u"ProtocolManager.Command /me is playing {}".format("MPD:{b}{artist}{b}{title}{b}{album}"))
            return True
        return False
