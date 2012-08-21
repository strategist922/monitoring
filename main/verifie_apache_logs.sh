#!/bin/bash


INTERNAL_SERVER_ERROR_CODE=500



countTotalInternalServerError(){
	logFile=$1
	grep -c "\" $INTERNAL_SERVER_ERROR_CODE " ${logFile}
}

extractUrlWhereErrorOccured(){
  logLine=$1
  echo ${logLine} | awk -F\" {'print $2'}
}

countDistinctInternalServerError(){
	logFile=$1
	grep "\" $INTERNAL_SERVER_ERROR_CODE " ${logFile} |  awk -F\" {'print $2'} | sort | uniq -c | sort -rn
}


rendEmailAnonyme(){
	logFile=$1
	sed -f ${RULES_DIR}/rendEmailAnonyme.rule $logFile
}

rendIdAnonyme(){
	logFile=$1
  sed -f ${RULES_DIR}/rendIdAnonyme.rule $logFile
}

aplatitDateJusqueProchainEspace() {
	logFile=$1
  sed -f ${RULES_DIR}/aplatitDate.rule $logFile 
}

aplatitDocumentEtParent(){
	logFile=$1
  sed -f ${RULES_DIR}/aplatitDocumentEtParent.rule $logFile 
}

aplatitMotContenantChiffre(){
 	logFile=$1
  sed -f ${RULES_DIR}/aplatitMotContenantChiffre.rule $logFile  
}

aplatitLaVilleEtDepartement(){
 	logFile=$1
  sed -f ${RULES_DIR}/aplatitLaVilleEtDepartement.rule $logFile  
}

aplatitSmileTemplate(){
 	logFile=$1
  sed -f ${RULES_DIR}/aplatitSmileTemplate.rule $logFile  
}

agregeLesFichierDeRegles() {
	# on supprime le cfichier aggrégé si il existe
	rm -f $1
	# on agrège tous les fichiers de règles (uniquement *.rule )
	for rule in ${RULES_DIR}/*.rule
	do
	   cat $rule >> $1
	done
}

lectureEtApplicationDesRegles() {
	logFile=$1
	ruleFile=$2
	sed -f $ruleFile $logFile
}



