#!/usr/bin/python2
#-*- coding: utf-8 -*-
## The MIT License (MIT)
## 
## Copyright (c) 2014 Jonas Møller
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
## THE SOFTWARE.

## Now playing script for smuxi

import Players
import socket
import sys
import re
from Config import Config
from Globals import *

class ConfigError(Exception):
    def __init__(self, value):
        self.value = value
    def __str__(self):
        return repr(self.value)

def sendSmuxiMessage(message):
    print(u"ProtocolManager.Command {}".format(message).encode("utf-8"))

def main():
    socket.setdefaulttimeout(SOCKET_TIMEOUT)
    sendSmuxiMessage(player.formatStatus(u"/me {}".format(Config.config["format"])))

if __name__ == '__main__':
    Config.load()

    for option in REQUIRED_OPTIONS:
        if not Config.config.get(option):
            raise ConfigError("Required option {} has not been set in config".format(repr(option)))

    formatters = {}
    rx_underlines = re.compile(r"__[\w\d]+__")
    for sub in dir(Players):
        if rx_underlines.match(sub):
            ## sub is a __sub__
            break
        formatters[sub.lower()] = getattr(Players, sub)

    player = formatters.get(Config.config["player"])
    if not player:
        raise ConfigError("Invalid player")

    main()

