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

./get_log_file.sh "$APACHE_LOG_FILE" "$SERVEURS" "$SERVEUR_USER" "${APACHE_FILE_TO_GET}" "${NOM_APPLICATION}" "$CONVERT_LOG_TO_UTF8" "$COMPRESS_IF_TOO_BIG_MO"
if [ "$?" != "0" ]; then exit "$?"; fi;

typeset -i CODE_RETOUR=0

headerStart
headerBody "Détail des erreurs 500 : "
headerEnd
countDistinctInternalServerError $APACHE_LOG_FILE

TOTAL_SERVER_ERROR=`countTotalInternalServerError $APACHE_LOG_FILE`
echo ""
echo "[INFO] Il y a eu $TOTAL_SERVER_ERROR erreurs 500 ";
echo ""
if [ "$TOTAL_SERVER_ERROR" -gt "$APACHE_SEUIL_ERREURS_500" ]; then
  echo ""
  afficheErreur "[FAILED] Il y a eu $TOTAL_SERVER_ERROR erreurs 500 (> seuil de $APACHE_SEUIL_ERREURS_500) ";
  CODE_RETOUR=30
  echo ""
fi

#Rapports jenkins
ls -d "../reports" > /dev/null
if [ $? -eq 0 ]; then 
  headerBody "Ecrit les données dans un fichier à part pour le plugin plot de Jenkins"
	echo "YVALUE=${TOTAL_SERVER_ERROR}" > ../reports/erreurs_500_totales
fi

exit $CODE_RETOUR
