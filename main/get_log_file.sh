#!/bin/bash

if [ "$LOG_FILE" == "" ]; then
	echo "You can't use this script without sourcing some variables. Check out propertiesFile.sh or get_and_parse_logs_from_conf.sh for details"
	exit 9
fi

date

. display.sh

headerStart
headerBody "recuperation du fichier $FILE_TO_GET"
headerBody "  sur $SERVEURS"
headerEnd 
 
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



