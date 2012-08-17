#!/bin/bash

export NOM_APPLICATION=mywebsite
export SEUIL_ERREURS_DISTINCTES=15
export SEUIL_ERREURS_TOTAL=280
export SERVEURS="frontal1 frontal2 frontal3"
export SERVEUR_USER=$NOM_APPLICATION
export FILE_TO_GET=/var/log/apps/keljob/keljob.log
export LOG_FILE=/tmp/${NOM_APPLICATION}-webapp.log
export CONVERT_LOG_TO_UTF8=no|yes
