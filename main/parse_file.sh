#!/bin/bash

if [ "$#" -lt "3" ]; then
	echo "Usage : ./parse_file.sh <LOG_FILE> <SEUIL_ERREURS_DISTINCTES> <SEUIL_ERREURS_TOTAL>"
	exit 99
fi

LOG_FILE=$1
SEUIL_ERREURS_DISTINCTES=$2
SEUIL_ERREURS_TOTAL=$3

. display.sh
. verifie_logs.sh
. repartition.sh

echo ""
echo "(seuil erreurs distinctes : $SEUIL_ERREURS_DISTINCTES)"
echo "(seuil erreurs total : $SEUIL_ERREURS_TOTAL)"

# Erreurs applicatives distinctes
echo ""
nbErreursDistinctes=`getNbErreursDistinctes $LOG_FILE`
echo ""
echo "Nombre d'erreurs distinctes : $nbErreursDistinctes"

# Erreurs applicatives totales
nbErreursTotal=`getNbErreurs $LOG_FILE`
echo "Nombre d'erreurs au total : $nbErreursTotal"
echo ""

if [ "$DISPLAY_CATALINA_ERROR" == "yes" ]; then
    headerStart
    headerBody "Répartition des erreurs Catalina"
    nbErreursCatalina=`getNbErreursDistinctesPourCatalina $LOG_FILE`
    echo ""
    echo "Nb erreurs Catalina $nbErreursCatalina"
    echo ""
    headerEnd
fi


# Rapport jenkins
ls -d "../reports" > /dev/null
if [ $? -eq 0 ]; then 
  headerBody "Ecrit les données dans un fichier à part pour le plugin plot de Jenkins"
	echo "YVALUE=${nbErreursTotal}" > ../reports/erreurs_totales
	echo "YVALUE=${nbErreursDistinctes}" > ../reports/erreurs_distinctes
fi


headerStart
headerBody "Répartition des erreurs sur la journée"
headerEnd
calculeLaRepartition $LOG_FILE

if [ $nbErreursTotal -gt $SEUIL_ERREURS_TOTAL ]; then
	afficheErreur "[FAILED] Le nombre d'erreurs totales a dépassé le seuil de $SEUIL_ERREURS_TOTAL" 
	afficheErreur "		> réel : $nbErreursTotal"
	exit 31
else 
  echo ""
  echo "[SUCCESS] Le nombre d'erreurs applicatives totales n'a pas dépassé le seuil"
fi

if [ $nbErreursDistinctes -gt $SEUIL_ERREURS_DISTINCTES ]; then
  afficheErreur "[FAILED] Le nombre d'erreurs distinctes a dépassé le seuil de $SEUIL_ERREURS_DISTINCTES" 
  afficheErreur "   > réel : $nbErreursDistinctes"

	exit 32
else 
  echo "[SUCCESS] Le nombre d'erreurs applicatives distinctes n'a pas dépassé le seuil"
  echo ""
fi




