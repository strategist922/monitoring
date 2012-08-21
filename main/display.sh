#/bin/bash

afficheErreur(){
	message=$1

	printf '\033[1;31m'
  echo $message
  printf '\033[0m'
}

headerStart(){
	message=$1
	echo "=========================================================================="
}

headerBody(){
	message=$1
	echo "== ${message}"
}

headerEnd(){
  message=$1
  echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-="
}

