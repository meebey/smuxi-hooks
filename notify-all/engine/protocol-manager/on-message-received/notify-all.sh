#!/bin/sh
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
xprop -id $focus _NET_WM_NAME|grep Smuxi
if [ "$?" -eq 1 ]; then
	notify-send "$SMUXI_CHAT_ID - $SMUXI_SENDER" "$SMUXI_MSG"
fi