#!/bin/bash

INTERNAL_SERVER_ERROR_CODE=500

countTotalInternalServerError(){
	logFile=$1
	zgrep -ac "\" $INTERNAL_SERVER_ERROR_CODE " ${logFile}
}

countDistinctInternalServerError(){
	logFile=$1
	zgrep -a "\" $INTERNAL_SERVER_ERROR_CODE " ${logFile} |  awk -F\" {'print $2'} | sort | uniq -c | sort -rn
}

extractUrlWhereErrorOccured(){
  logLine=$1
  echo ${logLine} | awk -F\" {'print $2'}
}



