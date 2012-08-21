#!/bin/bash

export NOM_APPLICATION=mywebsite
export SERVEURS="frontal1 frontal2 frontal3"
export SERVEUR_USER=$NOM_APPLICATION
export FILE_TO_GET=/var/log/apache2/www.mywebsite.fr_access.log.1
export LOG_FILE=/tmp/${NOM_APPLICATION}-apache.log

