#!/bin/sh
#
#        DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (c) 2014 Mirco Bauer <meebey@meebey.net>
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
# Script: away-nick.sh
#
# A Smuxi hook script. Automatically append and remove $AWAY_SUFFIX to/from the
# nick name when you go away using the /away command or by disconnecting all
# frontends from the smuxi-server.
#
# Usage: put script in
# ~/.local/share/smuxi/hooks/engine/protocol-manager/on-presence-status-changed/
#
##

AWAY_SUFFIX="|away"

case $SMUXI_PRESENCE_STATUS_CHANGED_NEW_STATUS in
    "Away")
        echo "ProtocolManager.Command /nick ${SMUXI_PROTOCOL_MANAGER_ME_ID%$AWAY_SUFFIX}$AWAY_SUFFIX"
        ;;
    "Online")
        echo "ProtocolManager.Command /nick ${SMUXI_PROTOCOL_MANAGER_ME_ID%$AWAY_SUFFIX}"
        ;;
esac
