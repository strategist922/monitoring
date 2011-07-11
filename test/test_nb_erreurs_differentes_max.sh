#!/bin/bash

export SHUNIT2_SCRIPTS=../lib/shunit2-2.1.6/src

testGetNbErreurs_quand_deux_erreurs_differentes_alors_retourne_deux_erreurs(){

	cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account for candidat with email=morjianeh@hotmail.fr
EOF

	std=`getNbErreurs $LOG_FILE 2>&1`
	assertEquals "nombre <ERROR> trouvés" 2 $?
}

testGetNbErreursDistinctes_quand_plusieurs_resultats_la_frequence_est_triee(){

	cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account 
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account 

EOF

	std=`getNbErreursDistinctes $LOG_FILE 2>&1`
	assertEquals "nombre <ERROR> trouvés" 2 $?
	assertEquals "detail des erreurs" "      2  <ERROR> Unable to create account 
      1  <ERROR> An error has occured during search" "${std}"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_alors_compter_une_seule_fois(){

	cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account for candidat with email=morjianeh@hotmail.fr
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search

EOF

	std=`getNbErreursDistinctes $LOG_FILE 2>&1`
	assertEquals "nombre <ERROR> trouvés" 2 $?
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_et_dates_differentes_alors_compter_une_seule_fois(){

	cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search
[01/07/2011 02:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search

EOF

	std=`getNbErreursDistinctes $LOG_FILE 2>&1`
	assertEquals "nombre <ERROR> différentes trouvés" 1 $?
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_avec_emails_differents_alors_compter_une_seule_fois(){

	cat > $LOG_FILE << EOF
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account for candidat with email=morjianeh@hotmail.fr
[01/07/2011 11:06:25.949-http-a-8080-18$29168554] <ERROR> Unable to create account for candidat with email=helenehelle.ostach@gmail.com

EOF
	
	std=`getNbErreursDistinctes $LOG_FILE 2>&1`
	assertEquals "nombre <ERROR> différentes trouvés" 1 $?
	# le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
	assertEquals "detail des erreurs" "      2  <ERROR> Unable to create account for candidat with email=mailXXX" "${std}"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_avec_id_differents_alors_compter_une_seule_fois(){

	cat > $LOG_FILE << EOF
[01/07/2011 14:00:10.488-http-a-8080-22$17977519] <ERROR> Unable to get cv for candidat id=11111111111
[01/07/2011 14:00:10.488-http-a-8080-22$17977519] <ERROR> Unable to get cv for candidat id=743251
EOF
	
	std=`getNbErreursDistinctes $LOG_FILE 2>&1`
	assertEquals "nombre <ERROR> différentes trouvés" 1 $?
	# le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
	assertEquals "detail des erreurs" "      2  <ERROR> Unable to get cv for candidat id=XXX" "${std}"
}


testRemplaceEmailParXXX_remplace_mot_contenant_email_par_mailXXX(){
	echo "with email=helenehelle.ostach@gmail.com incorrect" > $LOG_FILE
	mailNettoye=`remplaceEmailParXXX ${LOG_FILE}`
	assertEquals "email anonymé" "with email=mailXXX incorrect" "${mailNettoye}"
}

testRemplaceIdParXXX_remplace_mot_contenant_idEgal_par_idEgalXXX(){
	echo "candidat id=743251 bonjour" > $LOG_FILE
	idNettoye=`remplaceIdParXXX ${LOG_FILE}`
	assertEquals "id anonymé" "candidat id=XXX bonjour" "${idNettoye}"
}

oneTimeSetUp(){
	. ../main/verifie_logs.sh
	LOG_FILE=${__shunit_tmpDir}/stlog
}

. ${SHUNIT2_SCRIPTS}/shunit2
