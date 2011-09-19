#!/bin/bash

date

SEUIL_ERREURS_DISTINCTES=15
SEUIL_ERREURS_TOTAL=225
SERVEURS="serveur01 serveur02 serveur03 serveur04"
LOG_FILE=./monApp.log


. display.sh
. verifie_logs.sh

if [ -f $LOG_FILE ]; then rm $LOG_FILE; fi
touch $LOG_FILE
for serveur in $SERVEURS
do
	scp user@${serveur}:/var/log/apps/monApp/webapp.log /tmp/monApp-${serveur}.log
  cat /tmp/monApp-${serveur}.log >> $LOG_FILE
done

./parse_file.sh "$LOG_FILE" "$SEUIL_ERREURS_DISTINCTES" "$SEUIL_ERREURS_TOTAL"

