#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage : ./get_and_parse_apache_logs.sh <propertiesApacheSample.sh>"
  echo ""
  echo "<propertiesApacheSample.sh> sample : "
  echo ""
  cat propertiesApacheSample.sh
  exit 5
else 
  PROPERTIES_FILE=$1
fi

. ${PROPERTIES_FILE}
. verifie_apache_logs.sh
. display.sh

#TODO : si pas de paramètres, vérifier que les var sont settées. 
#				sinon il en faut 6
./get_log_file.sh #"$LOG_FILE" "$SERVEURS" "$SERVEUR_USER" "${FILE_TO_GET}" "${NOM_APPLICATION}" "$CONVERT_LOG_TO_UTF8"

TOTAL_SERVER_ERROR=`countTotalInternalServerError $LOG_FILE`
if [ "$TOTAL_SERVER_ERROR" != 0 ]; then
  afficheErreur "Il y a eu $TOTAL_SERVER_ERROR erreurs 500 !!! ";
fi

headerStart
headerBody "Détail des erreurs : "
headerEnd
countDistinctInternalServerError $LOG_FILE
