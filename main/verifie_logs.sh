#/bin/bash

getNbErreurs(){
	logFile=$1
	nbErreurs=`grep -c "<ERROR>" ${logFile}`
	return $nbErreurs;
}

getNbErreursDistinctes(){
 	logFile=$1
	tempLog='/tmp/verifie_logs.log'
	grep "<ERROR>" ${logFile} | awk -F] '{print $2}' > ${tempLog}
	rendIdAnonyme ${tempLog} > ${tempLog}_sans_id
	rendEmailAnonyme ${tempLog}_sans_id | sort | uniq -c > ${tempLog}_resume
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
