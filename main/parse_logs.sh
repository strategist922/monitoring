#!/bin/bash


SEUIL_ERREURS_TOTAL=10
SEUIL_ERREURS_DISTINCTES=2

LOG_FILE=./sampleKeljob.log

. display.sh
. verifie_logs.sh

date

echo ""
getNbErreurs $LOG_FILE
nbErreursTotal=$?
echo "Nombre d'erreurs au total : $nbErreursTotal"

echo ""
getNbErreursDistinctes $LOG_FILE
nbErreursDistinctes=$?

echo ""
echo "Nombre d'erreurs distinctes : $nbErreursDistinctes"
echo ""

if [ $nbErreursTotal -gt $SEUIL_ERREURS_TOTAL ]; then
	afficheErreur "[FAILED] Le nombre d'erreurs totales a dépassé le seuil de $SEUIL_ERREURS_TOTAL" 
	exit 1
fi

if [ $nbErreursDistinctes -gt $SEUIL_ERREURS_DISTINCTES ]; then
  afficheErreur "[FAILED] Le nombre d'erreurs distinctes a dépassé le seuil de $SEUIL_ERREURS_DISTINCTES" 
	exit 2
fi



