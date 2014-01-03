#!/bin/sh
#
#        DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (c) 2013 Christian Johnson <_c_@mail.com>
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
# Script: notify-all.sh
#
# A Smuxi hook script. Send a notification with every message received if the
# focused window is not Smuxi.
#
# Usage: put script in
# ~/.local/share/smuxi/hooks/engine/protocol-manager/on-message-received/
#
##

focus=`xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2`
xprop -id $focus _NET_WM_NAME|grep -q Smuxi
if [ "$?" -eq 1 ]; then
	notify-send "$SMUXI_CHAT_ID - $SMUXI_SENDER" "$SMUXI_MSG"
fi
