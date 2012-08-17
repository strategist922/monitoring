#!/bin/bash

LOG_FILE_REP=/tmp/explorimmo-webapp-repartition.log

displayLine() {
    if [ $2 -gt 0 ]
    then
        # compte le nombre d'erreurs sur une période
        count=`grep -wc "$1" $LOG_FILE_REP`
        # calcule le pourcentage
        percent=$(echo "$count $2" | awk '{printf("%5.2f",($1*100)/$2)}')
        # arrondit le pourcentage en entier
        rounded_percent=0
        if [ $count -gt 0 ]
        then
 		    rounded_percent=$(echo "$percent" | awk '{printf("%d",($1+1.0))}')
        fi
        # calcule la longueur de la barre
        progress=0
        barre=""
        while [ $progress -lt $rounded_percent ]
        do
           barre=$barre"##"
           progress=$((progress + 2))
        done
        # affiche le résultat
        if [ $count -gt 0 ]
        then
            echo $1 $barre "("$percent"% ,"$count"/"$2")"
        else
            echo $1 $barre "("$percent"%)"
        fi
    else
        echo $1 "( 0.00%)"
    fi
}

###########################################################################
# Calcule la répartition des erreurs sur la journée

calculeLaRepartition() {
 	LOG_FILE=$1

	grep -w "ERROR" $LOG_FILE | grep -o '[0-9][0-9]:[0-2][0-9]:[0-9][0-9]' | awk -F: '{print $1":00:00"}' > $LOG_FILE_REP
	grep -w "ERROR" $LOG_FILE | grep -o '[0-9][0-9]:[3-5][0-9]:[0-9][0-9]' | awk -F: '{print $1":30:00"}' >> $LOG_FILE_REP

	# calcule le nombre d'erreurs totales
	nbErreurs=`cat $LOG_FILE_REP | wc -l`

	numero=0
	while test $numero != 24
	do
	    first=`printf %02d:00:00 $numero`
	    second=`printf %02d:30:00 $numero`
	    #
	    displayLine $first $nbErreurs
	    displayLine $second $nbErreurs

	    # cette commande ajoute 1 à la variable "numero" :
	    numero=$(($numero + 1))
	done
	rm -f $LOG_FILE_REP
}

