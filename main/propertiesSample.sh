#!/bin/bash

export NOM_APPLICATION=mywebsite
export SEUIL_ERREURS_DISTINCTES=15
export SEUIL_ERREURS_TOTAL=280
export SERVEURS="frontal1 frontal2 frontal3"
export SERVEUR_USER=$NOM_APPLICATION
export FILE_TO_GET=/var/log/apps/mywebsite/webapp.log
export LOG_FILE=/tmp/${NOM_APPLICATION}-webapp.log
export CONVERT_LOG_TO_UTF8=no|yes
export COMPRESS_IF_TOO_BIG_MO=500 #if empty, it won't be compressed before remote copy #export COMPRESS_IF_TOO_BIG_MO=""

#specifique pour apache
export APACHE_FILE_TO_GET=/var/log/apache2/www.mywebsite.com_access.log.1				#it can be a zipped file, as long as zgrep can parse it
export APACHE_LOG_FILE=~/tmp/${NOM_APPLICATION}-apache.log                      #dans /home car /tmp est trop petit. Le fichier fait 1 GO par frontal.

