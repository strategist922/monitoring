#!/bin/bash

RULES_DIR="../main/rules/rules-enabled"

getNbErreurs(){
	logFile=$1
	grep -wc "ERROR" ${logFile}
}

getNbErreursDistinctes(){
 	logFile=$1
	tempLog='/tmp/verifie_logs.log'
	tempRules='/tmp/aden.rules'
	grep -w "ERROR" ${logFile} | awk -F] '{print $2}' > ${tempLog}
	agregeLesFichierDeRegles ${tempRules}
	lectureEtApplicationDesRegles ${tempLog} ${tempRules} | sort | uniq -c > ${tempLog}_resume
	nbErreurs=`cat ${tempLog}_resume | wc -l`
	echo "$nbErreurs"
	sort -nr ${tempLog}_resume >&2
	rm -f $tempLog*
}

## affine les erreurs propre Catalina
getNbErreursDistinctesForCatalina(){
 	logFile=$1
	tempLog='/tmp/verifie_logs_catalina.log'
	tempRules='/tmp/aden.rules'
	grep -w "\[Catalina\]" ${logFile} -A 1 | grep -v "\[Catalina\]" | grep -v "\--" > ${tempLog}
	agregeLesFichierDeRegles ${tempRules}
	lectureEtApplicationDesRegles ${tempLog} ${tempRules} | sort | uniq -c > ${tempLog}_resume
	sort -nr ${tempLog}_resume >&2
	rm -f $tempLog*
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



