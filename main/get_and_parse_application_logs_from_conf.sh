#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage : ./getAndParseLogs.sh <propertiesFile.sh>"
  echo ""
  echo "<propertiesFile.sh> sample : "
  echo ""
  cat propertiesSample.sh
  exit 5
else 
  PROPERTIES_FILE=$1
fi

. ${PROPERTIES_FILE}

./get_log_file.sh "$LOG_FILE" "${SERVEURS}" "$SERVEUR_USER" "${FILE_TO_GET}" "${NOM_APPLICATION}" "$CONVERT_LOG_TO_UTF8" "$COMPRESS_IF_TOO_BIG_MO"
if [ $? != 0 ]; then echo $?;  exit $?; fi;

./parse_file.sh "$LOG_FILE" "$SEUIL_ERREURS_DISTINCTES" "$SEUIL_ERREURS_TOTAL"
if [ $? != 0 ]; then echo $?;  exit $?; fi;


