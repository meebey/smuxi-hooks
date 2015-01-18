#!/usr/bin/python

import socket
import select
import re
from Config import Config
from Globals import *

## This is used to extract arguments from format strings like "{this} and {that}"
rx_find_kwargs = re.compile(r"{([\w_]+)}")

## Why not just use mpc you say? Because dependencies. Also, sockets are fun.
def getStatus():
    for option in ("mpd_port", "mpd_host"):
        if not Config.config.get(option):
            raise ConfigError("Required option {} has not been set in config".format(repr(option)))

    connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    connection.connect((Config.config["mpd_host"], Config.config["mpd_port"]))
    connection.sendall(b"currentsong\r\n")

    ## Receive the header from mpd
    header = b""
    while True:
        if not select.select([connection], [], [], SOCKET_TIMEOUT):
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

def formatStatus(form):
    info = getStatus()
    kwargs = rx_find_kwargs.findall(form)
    for arg in kwargs:
        if not info.get(arg):
            info[arg] = "Unknown"
    ## This seemed like the simplest solution for adding colors
    ## but it does mean that when writing a new module for a new player,
    ## the programmer has to remember to add this.
    info.update(COLORS)
    return form.format(**info)

