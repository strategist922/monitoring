#!/bin/bash

typeset -i CODE_RETOUR=0
PARAMS_COUNT=$#
PARAMS_COUNT_EXPECTED=7
if [ "$PARAMS_COUNT" == "$PARAMS_COUNT_EXPECTED" ]; then
  LOG_FILE=$1
  SERVEURS=$2
  SERVEUR_USER=$3
  FILE_TO_GET=$4
  NOM_APPLICATION=$5
  CONVERT_LOG_TO_UTF8=$6
  COMPRESS_IF_TOO_BIG_MO=$7
else
	echo "You can't use this script without passing $PARAMS_COUNT_EXPECTED variables :"
  echo '  LOG_FILE=$1
  SERVEURS=$2
  SERVEUR_USER=$3
  FILE_TO_GET=$4
  NOM_APPLICATION=$5
  CONVERT_LOG_TO_UTF8=$6
  COMPRESS_IF_TOO_BIG_MO=$7'
	exit 9
fi

. display.sh

headerStart
headerBody "recuperation du fichier $FILE_TO_GET"
headerBody "  sur $SERVEURS"
headerEnd 

date


if [ -f "$LOG_FILE" ]; then rm "$LOG_FILE"; fi
touch $LOG_FILE
filesToConcat=""
concatCommand="cat"
for serveur in $SERVEURS 
do
  fileToGet=$FILE_TO_GET
  #Compress distant file if necessary
  if [ "$COMPRESS_IF_TOO_BIG_MO" != "" ];then 
    tailleFichierOctets=`ssh ${SERVEUR_USER}@${serveur}.front.adencf.local stat -c %s ${FILE_TO_GET}`;    let CODE_RETOUR=$CODE_RETOUR+$?; 
    if [ "$tailleFichierOctets" -gt "${COMPRESS_IF_TOO_BIG_MO}000000" ]; then
      echo "Compression distante de ${FILE_TO_GET} car trop gros..."
      tempCompressedFile=`ssh ${SERVEUR_USER}@${serveur}.front.adencf.local basename $FILE_TO_GET`;       let CODE_RETOUR=$CODE_RETOUR+$?;
      tempCompressedFile="/tmp/${tempCompressedFile}.gz"
      ssh ${SERVEUR_USER}@${serveur}.front.adencf.local tar zcvf $tempCompressedFile ${FILE_TO_GET} > /dev/null 2>&1; let CODE_RETOUR=$CODE_RETOUR+$?;
      fileToGet=$tempCompressedFile
      concatCommand="zcat"
    fi
  fi

  # Rapatrie le fichier
	scp ${SERVEUR_USER}@${serveur}.front.adencf.local:${fileToGet} ${LOG_FILE}-${serveur}.log ;             let CODE_RETOUR=$CODE_RETOUR+$?;
  filesToConcat="$filesToConcat ${LOG_FILE}-${serveur}.log"
done

$concatCommand $filesToConcat > ${LOG_FILE}

# pour éviter problème d'encoding
if [ "$CONVERT_LOG_TO_UTF8" == "yes" ]; then
  iconv -f ISO-8859-1 -t UTF-8 $LOG_FILE -o ${LOG_FILE}.tmp ;                                             let CODE_RETOUR=$CODE_RETOUR+$?;
  mv ${LOG_FILE}.tmp $LOG_FILE;                                                                           let CODE_RETOUR=$CODE_RETOUR+$?;
fi

if [ $CODE_RETOUR -gt 0 ]; then exit 20; fi                                                               #surchage avec un code retour à 20 car la somme des codes retours peut revenir à 0 vu que c'est 255 max

