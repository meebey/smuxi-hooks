#!/bin/bash
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2014 AK0
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#
# Script: systeminfo.sh
#
# A Smuxi hook script.  Shows system info. Includes system kernel version,
# distro name, and CPU vendor information.
#
# Usage: put script in
# ~/.local/share/smuxi/hooks/frontend/command-manager/command-si/ change last
# directory to /command-systeminfo if you prefer typing /systeminfo instead of
# /si
##

kernel=`uname -a | cut -f 1 -d '#'`;
distro=`head -n1 /etc/issue | cut -f 1 -d '\'`;
cpuinfo=`grep "model name" /proc/cpuinfo | head -n1 | cut -f 2 -d :`
uptime=`uptime -p`;
echo "ProtocolManager.Command /say -KERNEL: $kernel -DISTRO: $distro -CPU: $cpuinfo  -UPTIME: $uptime"
