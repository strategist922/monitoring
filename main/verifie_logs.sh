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
	remplaceIdParXXX ${tempLog} > ${tempLog}_sans_id
	remplaceEmailParXXX ${tempLog}_sans_id | sort | uniq -c > ${tempLog}_resume
	sort -nr ${tempLog}_resume >&2
	nbErreurs=`cat ${tempLog}_resume | wc -l`
	rm -f $tempLog*
	return $nbErreurs;
}

remplaceEmailParXXX(){
	logFile=$1
	sed 's/[.a-zA-Z0-9\_\-]*@[.a-zA-Z0-9\-\-]*/mailXXX/g' $logFile 
}

remplaceIdParXXX(){
	logFile=$1
	sed 's/id=[.a-zA-Z0-9\_\-]*/id=XXX/g' $logFile 
}

#LOG_FILE=./keljob.log

#TOTAL=`grep -c "<ERROR>" ${LOG_FILE}`
#echo "$TOTAL erreurs en tout"


#echo "toutes les erreur triées"
#grep "<ERROR>" ${LOG_FILE} | awk -F\<ERROR\> '{print $2}'  | sort -n

#grep "<ERROR>" ./keljob.log.20110630.old | awk -F\< '{print $2}' | awk -F\> '{print substr($2,0,100)}' | awk -Flogin '{print $1}'  | awk -F= '{print $1}'  | awk -F@ '{print $1}' | awk -Faccount_id '{print $1}' | awk -Femail= '{print $1}'  | sort | uniq -dc | sort -n

