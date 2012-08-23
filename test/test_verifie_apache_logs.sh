#!/bin/bash

export SHUNIT2_SCRIPTS=../lib/shunit2-2.1.6/src

#########################################################################################
## Tests GetNbErreurs
#########################################################################################

testCountTotalInternalServerError(){

	cat > $LOG_FILE << EOF
192.168.16.254 41.141.85.111, 192.168.16.254 - - [20/Aug/2012:20:11:24 +0200] "POST /rubrique/user/aj/uploadPhoto HTTP/1.1" 500 384 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 34270413
192.168.16.254 41.141.85.111, 192.168.16.254 - - [20/Aug/2012:20:12:36 +0200] "POST /rubrique/user/aj/uploadPhoto HTTP/1.1" 500 384 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 32293878
192.168.16.254 88.186.239.246, 192.168.16.254 - - [20/Aug/2012:22:20:02 +0200] "POST /rubrique/user/aj/uploadDocument HTTP/1.1" 500 440 "http://www.mywebsite.com/depot-cv/#xtor=EPR-646-[rendez_vous_visible]-20110929" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 3.0.04506.30; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)" 68664693
192.168.16.254 88.189.71.186 - - [21/Aug/2012:00:14:33 +0200] "GET /width/0/height/0 HTTP/1.1" 404 37980 "http://cdnapi.kaltura.com/index.php/kwidget/wid/1_abca7q40/uiconf_id/5590821" "Mozilla/5.0 (Linux; U; Android 4.0.3; fr-fr; GT-I9100 Build/IML74K) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30" 376
192.168.16.254 41.250.235.144 - - [21/Aug/2012:00:17:59 +0200] "GET /upload/espace_pro/3073375/five75x30.gif HTTP/1.1" 304 - "http://www.mywebsite.com/rubrique/listprov=moteur&getInSession=-1&rub=_jeunes_diplomes" "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 500
EOF

	std=`countTotalInternalServerError $LOG_FILE 2>&1`
	assertEquals "nombre erreurs 500 trouvés" "3" "$std"
}

testCountTotalInternalServerError_shouldHandleCompressedFile(){

	cat > $LOG_FILE << EOF
192.168.16.254 41.141.85.111, 192.168.16.254 - - [20/Aug/2012:20:11:24 +0200] "POST /rubrique/user/aj/uploadPhoto HTTP/1.1" 500 384 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 34270413
192.168.16.254 41.141.85.111, 192.168.16.254 - - [20/Aug/2012:20:12:36 +0200] "POST /rubrique/user/aj/uploadProut HTTP/1.1" 500 384 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 32293878
EOF

  tar zcvf ${LOG_FILE}.gz ${LOG_FILE} > /dev/null 2>&1

	std=`countTotalInternalServerError ${LOG_FILE}.gz 2>&1`
	assertEquals "nombre erreurs 500 trouvés" "2" "$std"
}

testExtractUrlWhereErrorOccured(){

	LOG_LINE='192.168.16.254 41.141.85.111, 192.168.16.254 - - [20/Aug/2012:20:12:36 +0200] \"POST /rubrique/user/aj/uploadPhoto HTTP/1.1" 500 384 \"http://www.mywebsite.com/rubrique/user/viewProfil\" \"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1\" 32293878'

  expected="POST /rubrique/user/aj/uploadPhoto HTTP/1.1"

	std=`extractUrlWhereErrorOccured "${LOG_LINE}" 2>&1`
	assertEquals "url extraite" "$expected" "$std"
}

testCountDistinctInternalServerError_shouldDisplayCountAndUrl(){

	cat > $LOG_FILE << EOF
192.168.16.254 41.141.85.111, 192.168.16.254 - - [20/Aug/2012:20:12:36 +0200] "POST /rubrique/user/aj/uploadPhoto HTTP/1.1" 500 384 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 32293878
192.168.16.254 88.186.239.246, 192.168.16.254 - - [20/Aug/2012:22:20:02 +0200] "POST /rubrique/user/aj/uploadDocument HTTP/1.1" 500 440 "http://www.mywebsite.com/depot-cv/#xtor=EPR-646-[rendez_vous_visible]-20110929" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 3.0.04506.30; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)" 68664693
EOF

  EXPECTED="      1 POST /rubrique/user/aj/uploadPhoto HTTP/1.1
      1 POST /rubrique/user/aj/uploadDocument HTTP/1.1"

	std=`countDistinctInternalServerError $LOG_FILE 2>&1`
	assertEquals "nombre <ERROR> trouvés" "$EXPECTED" "$std"
}


testCountDistinctInternalServerError_shouldHandleCompressedFile(){

	cat > $LOG_FILE << EOF
192.168.16.254 41.141.85.111, 192.168.16.254 - - [20/Aug/2012:20:12:36 +0200] "POST /rubrique/user/aj/uploadPhoto HTTP/1.1" 500 384 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 32293878
EOF

  tar zcvf ${LOG_FILE}.gz ${LOG_FILE} > /dev/null 2>&1

  EXPECTED="      1 POST /rubrique/user/aj/uploadPhoto HTTP/1.1"

	std=`countDistinctInternalServerError ${LOG_FILE}.gz 2>&1`
	assertEquals "nombre <ERROR> trouvés" "$EXPECTED" "$std"
}

testCountDistinctInternalServerError_shouldHandleDistinctErrorsAndSortThem(){

	cat > $LOG_FILE << EOF
192.168.16.254 77.56.160.215, 192.168.16.254 - - [20/Aug/2012:06:39:58 +0200] "POST /rubrique/user/aj/addUrlPersoSocialNetwork HTTP/1.1" 500 321 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 6.0; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 85642
192.168.16.254 41.141.85.111, 192.168.16.254 - - [20/Aug/2012:20:11:24 +0200] "POST /rubrique/user/aj/uploadPhoto HTTP/1.1" 500 384 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 34270413
192.168.16.254 77.56.160.215, 192.168.16.254 - - [20/Aug/2012:06:40:11 +0200] "POST /rubrique/user/aj/addUrlPersoSocialNetwork HTTP/1.1" 500 401 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 6.0; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 15710
192.168.16.254 77.56.160.215, 192.168.16.254 - - [20/Aug/2012:06:40:36 +0200] "POST /rubrique/user/aj/addUrlPersoSocialNetwork HTTP/1.1" 500 441 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 6.0; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 19428
192.168.16.254 62.23.142.12, 192.168.16.254 - - [20/Aug/2012:09:34:25 +0200] "POST /rubrique/user/aj/addVisibiliteWeb HTTP/1.1" 500 334 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C; .NET4.0E; MS-RTC LM 8; yie8)" 113037
192.168.16.254 81.65.91.126, 192.168.16.254 - - [20/Aug/2012:11:18:55 +0200] "POST /rubrique/user/aj/uploadPhoto HTTP/1.1" 500 381 "-" "Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20100101 Firefox/14.0.1" 52000901
192.168.16.254 41.141.85.111, 192.168.16.254 - - [20/Aug/2012:20:12:36 +0200] "POST /rubrique/user/aj/uploadPhoto HTTP/1.1" 500 384 "http://www.mywebsite.com/rubrique/user/viewProfil" "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1" 32293878
192.168.16.254 88.186.239.246, 192.168.16.254 - - [20/Aug/2012:22:20:02 +0200] "POST /rubrique/user/aj/uploadDocument HTTP/1.1" 500 440 "http://www.mywebsite.com/depot-cv/#xtor=EPR-646-[rendez_vous_visible]-20110929" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB7.4; .NET CLR 3.0.04506.30; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)" 68664693

EOF

  EXPECTED="      3 POST /rubrique/user/aj/uploadPhoto HTTP/1.1
      3 POST /rubrique/user/aj/addUrlPersoSocialNetwork HTTP/1.1
      1 POST /rubrique/user/aj/uploadDocument HTTP/1.1
      1 POST /rubrique/user/aj/addVisibiliteWeb HTTP/1.1"

	std=`countDistinctInternalServerError $LOG_FILE 2>&1`
	assertEquals "nombre <ERROR> trouvés" "$EXPECTED" "$std"
}

oneTimeSetUp(){
	. ../main/verifie_apache_logs.sh
	LOG_FILE=${__shunit_tmpDir}/stlog
}

. ${SHUNIT2_SCRIPTS}/shunit2

