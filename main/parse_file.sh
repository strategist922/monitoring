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
echo "(seuil erreurs total : $SEUIL_ERREURS_TOTAL)"
echo "(seuil erreurs distinctes : $SEUIL_ERREURS_DISTINCTES)"

echo ""
nbErreursTotal=`getNbErreurs $LOG_FILE`
echo "Nombre d'erreurs au total : $nbErreursTotal"

echo ""
nbErreursDistinctes=`getNbErreursDistinctes $LOG_FILE`

echo ""
echo "Nombre d'erreurs distinctes : $nbErreursDistinctes"
echo ""

#Rapport jenkins
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
	exit 1
fi

if [ $nbErreursDistinctes -gt $SEUIL_ERREURS_DISTINCTES ]; then
  	afficheErreur "[FAILED] Le nombre d'erreurs distinctes a dépassé le seuil de $SEUIL_ERREURS_DISTINCTES" 
	exit 2
fi




