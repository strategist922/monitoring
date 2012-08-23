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

#./get_log_file.sh "$APACHE_LOG_FILE" "$SERVEURS" "$SERVEUR_USER" "${APACHE_FILE_TO_GET}" "${NOM_APPLICATION}" "$CONVERT_LOG_TO_UTF8" "$COMPRESS_IF_TOO_BIG_MO"

headerStart
headerBody "Détail des erreurs 500 : "
headerEnd
countDistinctInternalServerError $APACHE_LOG_FILE

TOTAL_SERVER_ERROR=`countTotalInternalServerError $APACHE_LOG_FILE`
if [ "$TOTAL_SERVER_ERROR" != 0 ]; then
  afficheErreur "Il y a eu $TOTAL_SERVER_ERROR erreurs 500 ";
fi
