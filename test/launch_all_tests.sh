#!/bin/bash

TEST_FILES=`find . -name "test_*" | grep -v ".svn"`
codeRetour=0

for file in ${TEST_FILES}; 
do
	echo ""
	echo "[Execution de $file ...]"
	echo 
	$file
	let codeRetour=$codeRetour+$?
done

exit $codeRetour

