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
# Script: deine-mudda.sh
#
# A Smuxi hook script. Sends a random "deine mudda" joke when issuing the /dm
# command.
#
# Usage: put script in
# ~/.local/share/smuxi/hooks/frontend/command-manager/command-dm/
#
##

DM[0]="Deine Mutter fragt bei SMS-Guru, wer dein Vater ist."
DM[1]="Deine Mutter sammelt Laub für den Blätterteig."
DM[2]="Deine Mutter schnallt sich n Dildo auf’n Kopf und spielt “Das Letzte Einhorn”."
DM[3]="Für deine Mutter ist Frittenfett ein Erfrischungsgetränk."
DM[4]="Deine Mudda erkennt Geschlechtskrankheiten am Geschmack."
DM[5]="Deine Mutter macht ihre Passfotos mit Google Earth."
DM[6]="Deine Mutter piept, wenn sie rückwärts geht."
DM[7]="Deine Mutter arbeitet in der Losbude als Niete."
DM[8]="Deine Mutter is so fett wenn die sich Facebook macht braucht sie 3 Accounts."
DM[9]="Deine Mutter sitzt bei Britt und ist zu 99,9 % dein Vater."
DM[10]="Deine Mutter lutscht Klosteine."
DM[11]="Deine Mutter stürzt öfters ab als Windows."
DM[12]="Deine Mutter ist wie ein Billardtisch, jeder hat mal eingelocht!"
DM[13]="Deine Mutter ist wie ein Senfglas, jeder darf sein Würstchen mal reinstecken."
DM[14]="Deine Mutter ist so fett, sie kann ihren Tanga als Fallschirm benutzen."
DM[15]="Deine Mutter sammelt hässliche Kinder!"
DM[16]="Deine Mudda spielt Counter-Strike mit einem Lenkrad."
DM[17]="Hab letztens 14 Tage Urlaub auf deiner Mutter gemacht und immer noch nicht alles gesehen!"
DM[18]="Deine Mutter steht nackt vor Kik und schreit: “Ich bin billiger!“"
DM[19]="Deine Mutter ist so doof, die stolpert über ein kabelloses Telefon."
DM[20]="Deine Mutter ist ein Funkloch."
DM[21]="Deine Mutter dreht Quadrate bei Tetris."
DM[22]="Deine Mutter stürzt öfter ab als Windows."
DM[23]="Deine Mutter arbeitet bei IKEA als unterste Schublade."
DM[24]="Deine Mutter ist so hässlich bei ihr wird eingebrochen um die Vorhänge zu schließen."

IDX=$(shuf -i 0-${#DM[@]} -n 1)
echo "ProtocolManager.Command /say ${DM[$IDX]}"
