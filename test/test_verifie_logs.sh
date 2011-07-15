!/bin/bash

export SHUNIT2_SCRIPTS=../lib/shunit2-2.1.6/src

testGetNbErreurs_quandDeuxErreursDifferentes_alorsRetourneDeuxErreurs(){

	cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account for candidat with email=brigitte@hotmail.fr
EOF

	std=`getNbErreurs $LOG_FILE 2>&1`
	assertEquals "nombre <ERROR> trouvés" "2" "$std"
}

testGetNbErreurs_quandCrochetErrorCrochet_alorsRetourneDeuxErreurs(){
  cat > $LOG_FILE << EOF
[ERROR] ATTENTION : Erreur applicative :null
[ERROR] ATTENTION : Erreur flux
EOF

  std=`getNbErreurs $LOG_FILE 2>&1`
  assertEquals "nombre [ERROR] trouvés" "2" "$std"

}

testGetNbErreurs_quandEspaceErrorEspace_alorsRetourneUneErreur(){
  cat > $LOG_FILE << EOF
Bonjour ERROR : Erreur applicative :null
EOF

  std=`getNbErreurs $LOG_FILE 2>&1`
  assertEquals "nombre [ERROR] trouvés" "1" "$std"

}

testGetNbErreurs_quandPlusDe255Error_alorsRetournePlusDe255Error(){
  cat > $LOG_FILE << EOF
Bonjour ERROR : Erreur applicative :null
EOF

	for ((i=0; i < 1000;i++)); do
		echo "ERROR $i" >> $LOG_FILE;
	done

  std=`getNbErreurs $LOG_FILE 2>&1`
  assertEquals "nombre [ERROR] trouvés" "1001" "${std}"

}

testGetNbErreursDistinctes_quandEspaceCrochetChevronError_afficheTroisErreurs(){

	cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] ERROR An error has occured during search
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] [ERROR] Unable to create account 
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] ERROR  Unable to create account 

EOF

	std=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
	assertEquals "Total ERROR distinct :  3" "$std"
}

testGetNbErreursDistinctes_quand_plusieurs_resultats_la_frequence_est_triee(){

  cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account 
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account 

EOF

  std=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
  assertEquals "message stdout" "Total ERROR distinct :  2" "$std"

  stderr=`getNbErreursDistinctes $LOG_FILE 2>&1 1>/dev/null`
  assertEquals "message stderr" "      2  <ERROR> Unable to create account 
      1  <ERROR> An error has occured during search" "${stderr}"
}


testGetNbErreursDistinctes_quand_deux_erreurs_identiques_alors_compter_une_seule_fois(){

	cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account for candidat with email=brigitte@hotmail.fr
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search

EOF

	std=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
	assertEquals "Total ERROR distinct :  2" "$std"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_et_dates_differentes_alors_compter_une_seule_fois(){

	cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search
[01/07/2011 02:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search

EOF

	std=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
	assertEquals "Total ERROR distinct :  1" "$std"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_avec_emails_differents_alors_compter_une_seule_fois(){

	cat > $LOG_FILE << EOF
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account for candidat with email=brigitte@hotmail.fr
[01/07/2011 11:06:25.949-http-a-8080-18$29168554] <ERROR> Unable to create account for candidat with email=dupont@mail.com

EOF
	
	std=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
	assertEquals "Total ERROR distinct :  1" "$std"
	# le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  stderr=`getNbErreursDistinctes $LOG_FILE 2>&1 1>/dev/null`
	assertEquals "detail des erreurs" "      2  <ERROR> Unable to create account for candidat with email=mailXXX" "${stderr}"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_avec_id_differents_alors_compter_une_seule_fois(){
	cat > $LOG_FILE << EOF
[01/07/2011 14:00:10.488-http-a-8080-22$17977519] <ERROR> Unable to get cv for candidat id=11111111111
[01/07/2011 14:00:10.488-http-a-8080-22$17977519] <ERROR> Unable to get cv for candidat id=123456
EOF
	
	std=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
	assertEquals "Total ERROR distinct :  1" "$std"
  stderr=`getNbErreursDistinctes $LOG_FILE 2>&1 1>/dev/null`
	# le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
	assertEquals "detail des erreurs" "      2  <ERROR> Unable to get cv for candidat id=XXX" "${stderr}"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_avec_dates_differentes_alors_compter_une_seule_fois(){
  cat > $LOG_FILE << EOF
[ERROR] - 10/07/2011 23:11:30 : fr.smile.fwk.base.ServletBase  - ATTENTION : Erreur applicative :null
EOF

  stdout=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
  assertEquals "Total ERROR distinct :  1" "$stdout"

  stderr=`getNbErreursDistinctes $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "      1  - XX/XX/XXXX XX:XX:XX : fr.smile.fwk.base.ServletBase  - ATTENTION : Erreur applicative :null" "${stderr}"

}

testRendMailAnonyme_remplace_mot_contenant_email_par_mailXXX(){
	echo "with email=dupond@mail.com incorrect" > $LOG_FILE
	mailNettoye=`rendEmailAnonyme ${LOG_FILE}`
	assertEquals "email anonymé" "with email=mailXXX incorrect" "${mailNettoye}"
}

testRendIdAnonyme_remplace_mot_contenant_idEgal_par_idEgalXXX(){
	echo "candidat id=743251 bonjour" > $LOG_FILE
	idNettoye=`rendIdAnonyme ${LOG_FILE}`
	assertEquals "id anonymé" "candidat id=XXX bonjour" "${idNettoye}"
}

testAplatitDate_remplace_dateHeure_par_XX(){
	echo "<ERROR> [01/07/2011 09:42] Unable to create account" > $LOG_FILE
	ligneNettoyee=`aplatitDateJusqueProchainEspace ${LOG_FILE}`
	assertEquals "date aplatie" "<ERROR> [XX/XX/XXXX XX:XX:XX] Unable to create account" "${ligneNettoyee}"
}

testAplatitDate_remplace_dateHeureEtIds_par_XX(){
	echo "<ERROR> [01/07/2011 09:42:45.579-http-a-8080-12$7984459] Unable to create account" > $LOG_FILE
	ligneNettoyee=`aplatitDateJusqueProchainEspace ${LOG_FILE}`
	assertEquals "date aplatie" "<ERROR> [XX/XX/XXXX XX:XX:XX] Unable to create account" "${ligneNettoyee}"
}

testAplatitDocumentEtParent_quandDocumentPointDoc_remplaceParPointDocument(){
	echo "Impossible de supprimer le fichier : /donnees/postuler_librement/5DAC3679773DD1749F448A1EC4E69C25455C/cv.doc" > $LOG_FILE
	ligneNettoyee=`aplatitDocumentEtParent $LOG_FILE`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
}

testAplatitDocumentEtParent_quandDocumentPointDocEtUndescore_remplaceParPointDocument(){
	echo "Impossible de supprimer le fichier : /donnees/postuler_librement/5DAC3679773DD_1749F448A1EC4E69C25455C/cv_decs.doc" > $LOG_FILE
	ligneNettoyee=`aplatitDocumentEtParent $LOG_FILE`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
}

testAplatitDocumentEtParent_quandDocumentPointDocx_remplaceParPointDocument(){
	echo "Impossible de supprimer le fichier : /donnees/postuler_librement/5DAC3679773DD1749F448A1EC4E69C25455C/cv.docx" > $LOG_FILE
	ligneNettoyee=`aplatitDocumentEtParent $LOG_FILE`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
}

testAplatitDocumentEtParent_quandDocumentPointPDF_remplaceParPointDocument(){
	echo "Impossible de supprimer le fichier : /donnees/postuler_librement/5DAC3679773DD1749F448A1EC4E69C25455C/cv.pdf" > $LOG_FILE
	ligneNettoyee=`aplatitDocumentEtParent $LOG_FILE`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
}




oneTimeSetUp(){
	. ../main/verifie_logs.sh
	LOG_FILE=${__shunit_tmpDir}/stlog
}

. ${SHUNIT2_SCRIPTS}/shunit2

