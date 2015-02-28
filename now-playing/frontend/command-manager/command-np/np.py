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

import engine
import subprocess
import getpass

USER = getpass.getuser()
player_pid = False

for mpla in engine.MPLAS:
    try:
        player_pid = subprocess.check_output(['pgrep', mpla, '-u', USER])
    except subprocess.CalledProcessError:
        player_pid = False
    if player_pid and engine.MprisPlayer(mpla).GetStatus():
        engine.MprisPlayer(mpla).GetTrackInfos()
        raise SystemExit(0)

try:
    player_pid = subprocess.check_output(['pgrep', 'midori', '-u', USER])
    if engine.Midori.GetTrackInfos():
        raise SystemExit(0)
    raise SystemExit(1)
except subprocess.CalledProcessError:
    pass

engine.Mpd.GetTrackInfos()