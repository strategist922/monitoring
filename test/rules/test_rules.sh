#!/bin/bash

export SHUNIT2_SCRIPTS=../lib/shunit2-2.1.6/src

#########################################################################################
## Tests rendEmailAnonyme
#########################################################################################

testRendMailAnonyme_remplace_mot_contenant_email_par_mailXXX(){
	echo "with email=dupond@mail.com incorrect" > $LOG_FILE
	mailNettoye=`rendEmailAnonyme ${LOG_FILE}`
	assertEquals "email anonymé" "with email=mailXXX incorrect" "${mailNettoye}"
	#
	mailNettoye=`lectureEtApplicationDesRegles ${LOG_FILE} ../main/rules/rules-available/rendEmailAnonyme.rule`
	assertEquals "email anonymé" "with email=mailXXX incorrect" "${mailNettoye}"
}

#########################################################################################
## Tests rendEmailAnonyme
#########################################################################################

testRendIdAnonyme_remplace_mot_contenant_idEgal_par_idEgalXXX(){
	echo "candidat id=743251 bonjour" > $LOG_FILE
	idNettoye=`rendIdAnonyme ${LOG_FILE}`
	assertEquals "id anonymé" "candidat id=XXX bonjour" "${idNettoye}"
	#
	mailNettoye=`lectureEtApplicationDesRegles ${LOG_FILE} ../main/rules/rules-available/rendIdAnonyme.rule`
	assertEquals "id anonymé" "candidat id=XXX bonjour" "${mailNettoye}"
}

#########################################################################################
## Tests aplatitDateJusqueProchainEspace
#########################################################################################

testAplatitDate_remplace_dateHeure_par_XX(){
	echo "<ERROR> [01/07/2011 09:42] Unable to create account" > $LOG_FILE
	ligneNettoyee=`aplatitDateJusqueProchainEspace ${LOG_FILE}`
	assertEquals "date aplatie" "<ERROR> [XX/XX/XXXX XX:XX:XX] Unable to create account" "${ligneNettoyee}"
	#
	ligneNettoyee=`lectureEtApplicationDesRegles ${LOG_FILE} ../main/rules/rules-available/aplatitDate.rule`
	assertEquals "date aplatie" "<ERROR> [XX/XX/XXXX XX:XX:XX] Unable to create account" "${ligneNettoyee}"
}

testAplatitDate_remplace_dateHeureEtIds_par_XX(){
	echo "<ERROR> [01/07/2011 09:42:45.579-http-a-8080-12$7984459] Unable to create account" > $LOG_FILE
	ligneNettoyee=`aplatitDateJusqueProchainEspace ${LOG_FILE}`
	assertEquals "date aplatie" "<ERROR> [XX/XX/XXXX XX:XX:XX] Unable to create account" "${ligneNettoyee}"
	#
	ligneNettoyee=`lectureEtApplicationDesRegles ${LOG_FILE} ../main/rules/rules-available/aplatitDate.rule`
	assertEquals "date aplatie" "<ERROR> [XX/XX/XXXX XX:XX:XX] Unable to create account" "${ligneNettoyee}"
}

#########################################################################################
## Tests aplatitDocumentEtParent
#########################################################################################

testAplatitDocumentEtParent_quandDocumentPointDoc_remplaceParPointDocument(){
	echo "Impossible de supprimer le fichier : /donnees/postuler_librement/5DAC3679773DD1749F448A1EC4E69C25455C/cv.doc" > $LOG_FILE
	ligneNettoyee=`aplatitDocumentEtParent $LOG_FILE`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
	#
	ligneNettoyee=`lectureEtApplicationDesRegles ${LOG_FILE} ../main/rules/rules-available/aplatitDocumentEtParent.rule`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
}

testAplatitDocumentEtParent_quandDocumentPointDOCMajuscules_remplaceParPointDocument(){
	echo "Impossible de supprimer le fichier : /donnees/postuler_librement/5DAC3679773DD1749F448A1EC4E69C25455C/cv.DOC" > $LOG_FILE
	ligneNettoyee=`aplatitDocumentEtParent $LOG_FILE`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
	#
	ligneNettoyee=`lectureEtApplicationDesRegles ${LOG_FILE} ../main/rules/rules-available/aplatitDocumentEtParent.rule`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
}

testAplatitDocumentEtParent_quandDocumentPointDocEtUndescore_remplaceParPointDocument(){
	echo "Impossible de supprimer le fichier : /donnees/postuler_librement/5DAC3679773DD_1749F448A1EC4E69C25455C/cv_decs.doc" > $LOG_FILE
	ligneNettoyee=`aplatitDocumentEtParent $LOG_FILE`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
	#
	ligneNettoyee=`lectureEtApplicationDesRegles ${LOG_FILE} ../main/rules/rules-available/aplatitDocumentEtParent.rule`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
}

testAplatitDocumentEtParent_quandDocumentPointDocx_remplaceParPointDocument(){
	echo "Impossible de supprimer le fichier : /donnees/postuler_librement/5DAC3679773DD1749F448A1EC4E69C25455C/cv.docx" > $LOG_FILE
	ligneNettoyee=`aplatitDocumentEtParent $LOG_FILE`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
	#
	ligneNettoyee=`lectureEtApplicationDesRegles ${LOG_FILE} ../main/rules/rules-available/aplatitDocumentEtParent.rule`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
}

testAplatitDocumentEtParent_quandDocumentPointPdf_remplaceParPointDocument(){
	echo "Impossible de supprimer le fichier : /donnees/postuler_librement/5DAC3679773DD1749F448A1EC4E69C25455C/cv.pdf" > $LOG_FILE
	ligneNettoyee=`aplatitDocumentEtParent $LOG_FILE`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
	#
	ligneNettoyee=`lectureEtApplicationDesRegles ${LOG_FILE} ../main/rules/rules-available/aplatitDocumentEtParent.rule`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
}

testAplatitDocumentEtParent_quandDocumentPointPDFMajuscules_remplaceParPointDocument(){
	echo "Impossible de supprimer le fichier : /donnees/postuler_librement/5DAC3679773DD1749F448A1EC4E69C25455C/cv.PDF" > $LOG_FILE
	ligneNettoyee=`aplatitDocumentEtParent $LOG_FILE`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
	#
	ligneNettoyee=`lectureEtApplicationDesRegles ${LOG_FILE} ../main/rules/rules-available/aplatitDocumentEtParent.rule`
	assertEquals "document aplatit" "Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "$ligneNettoyee"
}

#########################################################################################
## Tests aplatitMotContenantChiffre
#########################################################################################

testAplatitMotContenantChiffre_quandUnChiffreEntoureEspaces_remplaceParXXXX(){
  echo "avant bonjour1 apres" > $LOG_FILE
  ligneNettoyee=`aplatitMotContenantChiffre $LOG_FILE`
  assertEquals "document aplatit" "avant XXXX apres" "$ligneNettoyee"
  # 
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitMotContenantChiffre.rule`
  assertEquals "document aplatit" "avant XXXX apres" "$ligneNettoyee"
}

testAplatitMotContenantChiffre_quandUnChiffreApresDeuxPoints__remplaceParXXXX(){
  echo "Impossible de supprimer le fichier : bon1jour flo" > $LOG_FILE
  ligneNettoyee=`aplatitMotContenantChiffre $LOG_FILE`
  assertEquals "document aplatit" "Impossible de supprimer le fichier : XXXX flo" "$ligneNettoyee"
  # 
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitMotContenantChiffre.rule`
  assertEquals "document aplatit" "Impossible de supprimer le fichier : XXXX flo" "$ligneNettoyee"
}

testAplatitMotContenantChiffre_quandUnChiffreEnFinDeLigne_remplaceParXXXX(){
  echo "Impossible de supprimer le fichier bon1jour" > $LOG_FILE
  ligneNettoyee=`aplatitMotContenantChiffre $LOG_FILE`
  assertEquals "document aplatit" "Impossible de supprimer le fichier XXXX" "$ligneNettoyee"
  # 
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitMotContenantChiffre.rule`
  assertEquals "document aplatit" "Impossible de supprimer le fichier XXXX" "$ligneNettoyee"
}

testAplatitMotContenantChiffre_quandVirguleEtParentheses_remplaceParXXXX(){
  echo "fichier 16,12,18,(null),8,10,17,1,4,3,6,9,15,7,11,5,13,14,20,19,23,2,22 du repertoire" > $LOG_FILE
  ligneNettoyee=`aplatitMotContenantChiffre $LOG_FILE`
  assertEquals "document aplatit" "fichier XXXX du repertoire" "$ligneNettoyee"
  # 
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitMotContenantChiffre.rule`
  assertEquals "document aplatit" "fichier XXXX du repertoire" "$ligneNettoyee"
}

testAplatitMotContenantChiffre_quandSlash_remplaceParXXXX(){
  echo "fichier toto/tata1 du repertoire" > $LOG_FILE
  ligneNettoyee=`aplatitMotContenantChiffre $LOG_FILE`
  assertEquals "document aplatit" "fichier XXXX du repertoire" "$ligneNettoyee"
  # 
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitMotContenantChiffre.rule`
  assertEquals "document aplatit" "fichier XXXX du repertoire" "$ligneNettoyee"
}

testAplatitMotContenantChiffre_quandGuillement_remplaceParXXXX(){
  echo "fichier toto\"tata1 du repertoire" > $LOG_FILE
  ligneNettoyee=`aplatitMotContenantChiffre $LOG_FILE`
  assertEquals "document aplatit" "fichier XXXX du repertoire" "$ligneNettoyee"
  # 
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitMotContenantChiffre.rule`
  assertEquals "document aplatit" "fichier XXXX du repertoire" "$ligneNettoyee"
}

testAplatitMotContenantChiffre_quandTiret_remplaceParXXXX(){
  echo "fichier toto-tata1 du repertoire" > $LOG_FILE
  ligneNettoyee=`aplatitMotContenantChiffre $LOG_FILE`
  assertEquals "document aplatit" "fichier XXXX du repertoire" "$ligneNettoyee"
  # 
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitMotContenantChiffre.rule`
  assertEquals "document aplatit" "fichier XXXX du repertoire" "$ligneNettoyee"
}

#########################################################################################
## Tests aplatitVille
#########################################################################################

testAplatitVille_cas_nominal() {
  echo "com.smile.servlet.params.VilleParameter  - getLibelleDept: message = CA_PS_REF_VILLE:RECUP_LIBELLE_VILLE - Code ville : DUCOS Departement : 97: - Erreur - Aucune donnee trouvee" > $LOG_FILE
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitLaVilleEtDepartement.rule`
  assertEquals "com.smile.servlet.params.VilleParameter  - getLibelleDept: message = CA_PS_REF_VILLE:RECUP_LIBELLE_VILLE - Code ville : XXXX Departement : XXXX: - Erreur - Aucune donnee trouvee" "$ligneNettoyee"
}

testAplatitVille_ville_avec_accent() {
  echo "com.smile.servlet.params.VilleParameter  - getLibelleDept: message = CA_PS_REF_VILLE:RECUP_LIBELLE_VILLE - Code ville : Poûèt-héou Departement : 97: - Erreur - Aucune donnee trouvee" > $LOG_FILE
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitLaVilleEtDepartement.rule`
  assertEquals "com.smile.servlet.params.VilleParameter  - getLibelleDept: message = CA_PS_REF_VILLE:RECUP_LIBELLE_VILLE - Code ville : XXXX Departement : XXXX: - Erreur - Aucune donnee trouvee" "$ligneNettoyee"
}

testAplatitVille_ville_avec_plusieurs_mots() {
  echo "com.smile.servlet.params.VilleParameter  - getLibelleDept: message = CA_PS_REF_VILLE:RECUP_LIBELLE_VILLE - Code ville : saint jûnien de haute-vienne Departement : 97: - Erreur - Aucune donnee trouvee" > $LOG_FILE
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitLaVilleEtDepartement.rule`
  assertEquals "com.smile.servlet.params.VilleParameter  - getLibelleDept: message = CA_PS_REF_VILLE:RECUP_LIBELLE_VILLE - Code ville : XXXX Departement : XXXX: - Erreur - Aucune donnee trouvee" "$ligneNettoyee"
}

testAplatitVille_departement_corse() {
  echo "com.smile.servlet.params.VilleParameter  - getLibelleDept: message = CA_PS_REF_VILLE:RECUP_LIBELLE_VILLE - Code ville : Ducos  Departement : 2A: - Erreur - Aucune donnee trouvee" > $LOG_FILE
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitLaVilleEtDepartement.rule`
  assertEquals "com.smile.servlet.params.VilleParameter  - getLibelleDept: message = CA_PS_REF_VILLE:RECUP_LIBELLE_VILLE - Code ville : XXXX Departement : XXXX: - Erreur - Aucune donnee trouvee" "$ligneNettoyee"
}

#########################################################################################
## Tests aplatitSmileTemplate
#########################################################################################

testAplatitSmileTemplate_nominalCase() {
  echo "com.smile.servlet.tools.template  - Template Introuvable : /data/www/explorimmo/webapp/templates/../cobranding/templates/EAnnonce/t_EAnnonce_periode_lig_table.html" > $LOG_FILE
  ligneNettoyee=`lectureEtApplicationDesRegles $LOG_FILE ../main/rules/rules-available/aplatitSmileTemplate.rule`
  assertEquals "com.smile.servlet.tools.template  - Template Introuvable : XXXX" "$ligneNettoyee"
}


oneTimeSetUp(){
	. ../main/verifie_logs.sh
	LOG_FILE=${__shunit_tmpDir}/stlog
}

. ${SHUNIT2_SCRIPTS}/shunit2

