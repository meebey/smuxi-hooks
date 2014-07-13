#!/bin/bash
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
# Script: topic-diff.sh
#
# A Smuxi hook script. This hooks shows the word differences of the topic after
# topic changes.
#
# Usage: put script in
# ~/.local/share/smuxi/hooks/engine/session/on-event-message/
#
##

if [ "$SMUXI_CHAT_TYPE" != "Group" ]; then
    exit 0
fi
if ! echo "$SMUXI_MSG" | grep -q " changed the topic "; then
    exit 0
fi

TOPIC_REGEX="^.*? changed the topic of .*? to: (.*)$"
TOPIC_FILE="${SMUXI_PROTOCOL_MANAGER_PROTOCOL}_${SMUXI_PROTOCOL_MANAGER_NETWORK}_${SMUXI_CHAT_ID}_TOPIC.txt"
[[ "$SMUXI_MSG" =~ $TOPIC_REGEX ]]
NEW_TOPIC="${BASH_REMATCH[1]}"
OLD_TOPIC="$(cat $TOPIC_FILE)"
echo "$NEW_TOPIC" > "$TOPIC_FILE"
WDIFF=$(wdiff --start-delete='{-' --end-delete='}' --start-insert='{+' --end-insert='}' <(echo $OLD_TOPIC) <(echo $NEW_TOPIC))

echo "Session.Command /echo $WDIFF"
