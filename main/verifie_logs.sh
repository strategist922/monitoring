#/bin/bash

getNbErreurs(){
	logFile=$1
	nbErreurs=`grep -wc "ERROR" ${logFile}`
	return $nbErreurs;
}

getNbErreursDistinctes(){
 	logFile=$1
	tempLog='/tmp/verifie_logs.log'
	grep -w "ERROR" ${logFile} | awk -F] '{print $2}' > ${tempLog}
	rendIdAnonyme ${tempLog} > ${tempLog}_sans_id
	aplatitDateJusqueProchainEspace ${tempLog}_sans_id > ${tempLog}_sans_id_ni_date
	rendEmailAnonyme ${tempLog}_sans_id_ni_date | sort | uniq -c > ${tempLog}_resume
	sort -nr ${tempLog}_resume >&2
	nbErreurs=`cat ${tempLog}_resume | wc -l`
	rm -f $tempLog*
	return $nbErreurs;
}

rendEmailAnonyme(){
	logFile=$1
	sed 's/[.a-zA-Z0-9\_\-]*@[.a-zA-Z0-9\-\-]*/mailXXX/g' $logFile 
}

rendIdAnonyme(){
	logFile=$1
	sed 's/id=[.a-zA-Z0-9\_\-]*/id=XXX/g' $logFile 
}

aplatitDateJusqueProchainEspace() {
	logFile=$1
	sed 's#[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9][.:a-zA-Z0-9\_\-]*#XX/XX/XXXX XX:XX:XX#g' $logFile 
}
