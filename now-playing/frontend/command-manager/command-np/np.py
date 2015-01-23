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

def shellquote(s):
    return "'" + s.replace("'", "'\\''") + "'"

USER = getpass.getuser()

for mpla in engine.MPLAS:
    process = subprocess.Popen('pgrep %s -u %s' %(shellquote(mpla), shellquote(USER)), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    player_pid, err = process.communicate()
    if player_pid and engine.MprisPlayer(mpla).GetStatus():
        engine.MprisPlayer(mpla).GetTrackInfos()
        break
