#!/bin/bash

export SHUNIT2_SCRIPTS=../lib/shunit2-2.1.6/src

#########################################################################################
## Tests GetNbErreurs
#########################################################################################

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

#########################################################################################
## Tests GetNbErreursDistinctes
#########################################################################################

testGetNbErreursDistinctes_quandEspaceCrochetChevronError_afficheTroisErreurs(){

	cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] ERROR An error has occured during search
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] [ERROR] Unable to create account 
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] ERROR  Unable to create account 

EOF

	std=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
	assertEquals "nombre ERROR distinctes" "3" "$std"
}

testGetNbErreursDistinctes_quand_plusieurs_resultats_la_frequence_est_triee(){

  cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account 
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account 

EOF

  std=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR distinctes" "2" "$std"

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
	assertEquals "nombre ERROR distinctes" "2" "$std"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_et_dates_differentes_alors_compter_une_seule_fois(){

	cat > $LOG_FILE << EOF
[01/07/2011 01:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search
[01/07/2011 02:29:12.001-http-a-8080-10$549007] <ERROR> An error has occured during search

EOF

	std=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
	assertEquals "nombre ERROR distinctes" "1" "$std"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_avec_emails_differents_alors_compter_une_seule_fois(){

	cat > $LOG_FILE << EOF
[01/07/2011 09:42:45.579-http-a-8080-12$7984459] <ERROR> Unable to create account for candidat with email=brigitte@hotmail.fr
[01/07/2011 11:06:25.949-http-a-8080-18$29168554] <ERROR> Unable to create account for candidat with email=dupont@mail.com

EOF
	
	std=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
	assertEquals "nombre ERROR distinctes" "1" "$std"
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
	assertEquals "nombre ERROR distinctes" "1" "$std"
  stderr=`getNbErreursDistinctes $LOG_FILE 2>&1 1>/dev/null`
	# le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
	assertEquals "detail des erreurs" "      2  <ERROR> Unable to get cv for candidat id=XXX" "${stderr}"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_avec_dates_differentes_alors_compter_une_seule_fois(){
  cat > $LOG_FILE << EOF
[ERROR] - 10/07/2011 23:11:30 : fr.smile.fwk.base.ServletBase  - ATTENTION : Erreur applicative :null
EOF

  stdout=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR distinctes" "1" "$stdout"

  stderr=`getNbErreursDistinctes $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "      1  - XX/XX/XXXX XX:XX:XX : fr.smile.fwk.base.ServletBase  - ATTENTION : Erreur applicative :null" "${stderr}"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_avec_docs_differents_alors_compter_une_seule_fois(){
  cat > $LOG_FILE << EOF
[ERROR] - 10/07/2011 23:11:30 : fr.smile.fwk.base.ServletBase  - Impossible de supprimer le fichier : /donnees/postuler_librement/abcd/cv.doc
[ERROR] - 10/07/2011 23:11:30 : fr.smile.fwk.base.ServletBase  - Impossible de supprimer le fichier : /donnees/postuler_librement/97A1EC4E69C25455C/document.pdf
EOF

  stdout=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR distinctes" "1" "$stdout"

  stderr=`getNbErreursDistinctes $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "      2  - XX/XX/XXXX XX:XX:XX : fr.smile.fwk.base.ServletBase  - Impossible de supprimer le fichier : /donnees/postuler_librement/XXX/document" "${stderr}"
}

testGetNbErreursDistinctes_quand_deux_erreurs_identiques_avec_mots_contenant_chiffre_alors_compter_une_seule_fois(){
  cat > $LOG_FILE << EOF
[ERROR] - 10/07/2011 23:11:30 : fr.smile.fwk.base.ServletBase  - Impossible de supprimer le fichier : bonjour1
[ERROR] - 10/07/2011 23:11:30 : fr.smile.fwk.base.ServletBase  - Impossible de supprimer le fichier : bonjour2
EOF

  stdout=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR distinctes" "1" "$stdout"

  stderr=`getNbErreursDistinctes $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "      2  - XX/XX/XXXX XX:XX:XX : fr.smile.fwk.base.ServletBase  - Impossible de supprimer le fichier : XXXX" "${stderr}"
}


testGetNbErreursDistinctes_quand_deux_erreurs_identiques_sur_erreur_rest_endeca(){
  cat > $LOG_FILE << EOF
[ERROR] - 06/11/2012 07:31:56 : com.explorimmo.rest.exceptionmapper.ThrowableExceptionMapper  - com.explorimmo.core.exception.ExplorimmoTechnicalException: Problème de connexion Endeca lors de l\'exécution de lolollolo
[ERROR] - 06/11/2012 07:31:56 : com.explorimmo.rest.exceptionmapper.ThrowableExceptionMapper  - com.explorimmo.core.exception.ExplorimmoTechnicalException: Problème de connexion Endeca lors de l\'exécution de 808787870
EOF

  stdout=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR distinctes" "1" "$stdout"

  stderr=`getNbErreursDistinctes $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "      2  - XX/XX/XXXX XX:XX:XX : com.explorimmo.rest.exceptionmapper.ThrowableExceptionMapper  - com.explorimmo.core.exception.ExplorimmoTechnicalException: Problème de connexion Endeca XXXXXX" "${stderr}"
}


testGetNbErreursDistinctes_quand_deux_erreurs_identiques_sur_erreur_rest_auto_completion(){
  cat > $LOG_FILE << EOF
[ERROR] - 06/11/2012 07:31:56 : com.explorimmo.rest.resources.LocationResource  - Erreur lors de la récupération de la ressource LocationResource [prefix=roquefort les
[ERROR] - 06/11/2012 07:31:56 : com.explorimmo.rest.resources.LocationResource  - Erreur lors de la récupération de la ressource LocationResource [prefix=puteaux
EOF

  stdout=`getNbErreursDistinctes $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR distinctes" "1" "$stdout"

  stderr=`getNbErreursDistinctes $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "      2  - XX/XX/XXXX XX:XX:XX : com.explorimmo.rest.resources.LocationResource  - Erreur lors de la récupération de la ressource LocationResource [prefix=XXXX" "${stderr}"
}


#########################################################################################
## Tests getNbErreursDistinctesPourCatalina
#########################################################################################

testGetNbErreursDistinctesPourCatalina_pas_d_erreurs_catalina(){
  cat > $LOG_FILE << EOF
[ERROR] - 06/11/2012 07:31:56 : com.explorimmo.rest.exceptionmapper.ThrowableExceptionMapper  - com.explorimmo.core.exception.ExplorimmoTechnicalException: Problème de connexion Endeca lors de l'exécution de lolollolo
[ERROR] - 06/11/2012 07:31:56 : com.explorimmo.rest.exceptionmapper.ThrowableExceptionMapper  - com.explorimmo.core.exception.ExplorimmoTechnicalException: Problème de connexion Endeca lors de l'exécution de 808787870
EOF

  stdout=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR catalina" "0" "$stdout"

  stderr=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "" "${stderr}"
}

testGetNbErreursDistinctesPourCatalina_une_erreur_catalina(){
  cat > $LOG_FILE << EOF
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
com.endeca.navigation.MyException: Connection unable to determine response code.
EOF

  stdout=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR catalina" "1" "$stdout"


  stderr=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "      1 com.endeca.navigation.MyException: Connection unable to determine response code." "${stderr}"
}

testGetNbErreursDistinctesPourCatalina_plusieurs_erreur_catalina_identiquee(){
  cat > $LOG_FILE << EOF
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
com.endeca.navigation.MyException: Connection unable to determine response code.
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
com.endeca.navigation.MyException: Connection unable to determine response code.
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
com.endeca.navigation.MyException: Connection unable to determine response code.
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
com.endeca.navigation.MyException: Connection unable to determine response code.
EOF

  stdout=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR catalina" "4" "$stdout"

  stderr=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "      4 com.endeca.navigation.MyException: Connection unable to determine response code." "${stderr}"
}


testGetNbErreursDistinctesPourCatalina_plusieurs_erreur_catalina_differentes_active_une_regle(){
  cat > $LOG_FILE << EOF
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
Unable to create account for candidat with email=brigitte@hotmail.fr
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
Unable to create account for candidat with email=dupont@mail.com
EOF

  stdout=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR catalina" "2" "$stdout"

  stderr=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "      2 Unable to create account for candidat with email=mailXXX" "${stderr}"
}

testGetNbErreursDistinctesPourCatalina_plusieurs_erreur_catalina_differentes(){
  cat > $LOG_FILE << EOF
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
com.endeca.navigation.MyException: Connection unable to determine response code.
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
Impossible de voir la page
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
com.endeca.navigation.MyException: Connection unable to determine response code.
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
Tomcat doesn't understand.
EOF

  stdout=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR catalina" "4" "$stdout"

  stderr=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "      2 com.endeca.navigation.MyException: Connection unable to determine response code.
      1 Tomcat doesn't understand.
      1 Impossible de voir la page" "${stderr}"
}

testGetNbErreursDistinctesPourCatalina_plusieurs_erreur_catalina_mal_construites(){
  cat > $LOG_FILE << EOF
[ERROR] - 19/11/2012 09:56:10 : org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/].[e-explorimmo-webapp]  - "Servlet.service()" pour la servlet e-explorimmo-webap
EOF

  stdout=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>/dev/null`
  assertEquals "nombre ERROR catalina" "0" "$stdout"

  stderr=`getNbErreursDistinctesPourCatalina $LOG_FILE 2>&1 1>/dev/null`
  # le detail doit contenir en début de ligne le nombre d'occurence de l'erreur"
  assertEquals "detail des erreurs" "" "${stderr}"
}

oneTimeSetUp(){
	. ../main/verifie_logs.sh
	LOG_FILE=${__shunit_tmpDir}/stlog
}

. ${SHUNIT2_SCRIPTS}/shunit2

