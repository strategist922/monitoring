#!/bin/bash

PARAMS_COUNT=$#
PARAMS_COUNT_EXPECTED=6
if [ "$PARAMS_COUNT" == "$PARAMS_COUNT_EXPECTED" ]; then
  LOG_FILE=$1
  SERVEURS=$2
  SERVEUR_USER=$3
  FILE_TO_GET=$4
  NOM_APPLICATION=$5
  CONVERT_LOG_TO_UTF8=$6
else
	echo "You can't use this script without passing $PARAMS_COUNT_EXPECTED variables :"
  echo '  LOG_FILE=$1
  SERVEURS=$2
  SERVEUR_USER=$3
  FILE_TO_GET=$4
  NOM_APPLICATION=$5
  CONVERT_LOG_TO_UTF8=$6'
	exit 9
fi

. display.sh

headerStart
headerBody "recuperation du fichier $FILE_TO_GET"
headerBody "  sur $SERVEURS"
headerEnd 

date
 
if [ -f "$LOG_FILE" ]; then rm "$LOG_FILE"; fi
touch $LOG_FILE
for serveur in $SERVEURS 
do
	scp ${SERVEUR_USER}@${serveur}.front.adencf.local:${FILE_TO_GET} ${LOG_FILE}-${serveur}.log
  cat ${LOG_FILE}-${serveur}.log >> ${LOG_FILE}
done

# pour éviter problème d'encoding
if [ "$CONVERT_LOG_TO_UTF8" == "yes" ]; then
  iconv -f ISO-8859-1 -t UTF-8 $LOG_FILE -o ${LOG_FILE}.tmp
  mv ${LOG_FILE}.tmp $LOG_FILE
fi



