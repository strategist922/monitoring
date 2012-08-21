#!/bin/bash

INTERNAL_SERVER_ERROR_CODE=500

countTotalInternalServerError(){
	logFile=$1
	grep -c "\" $INTERNAL_SERVER_ERROR_CODE " ${logFile}
}

countDistinctInternalServerError(){
	logFile=$1
	grep "\" $INTERNAL_SERVER_ERROR_CODE " ${logFile} |  awk -F\" {'print $2'} | sort | uniq -c | sort -rn
}

extractUrlWhereErrorOccured(){
  logLine=$1
  echo ${logLine} | awk -F\" {'print $2'}
}



