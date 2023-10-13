#!/bin/bash
OPTION1=$1
OPTION2=$2
OPTION3=$3

sudo apt install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils curl git python3 cmake >/dev/null 2>&1
if [[ ("${OPTION1^^}" == "WIN") ]]; then
	sudo apt install -y nsis >/dev/null 2>&1
	sudo apt install -y g++-mingw-w64-x86-64 >/dev/null 2>&1
	#sudo update-alternatives --config x86_64-w64-mingw32-g++ # Set the default mingw32 g++ compiler option to posix.
else
	sudo apt update -y >/dev/null 2>&1
	sudo apt upgrade -y >/dev/null 2>&1
	sudo apt-get install curl build-essential libtool autotools-dev automake pkg-config python3 bsdmainutils >/dev/null 2>&1
fi

if [[ ("${OPTION1^^}" == "PRE") ]]; then
	echo
	echo "=========================================="
	echo "=     UPDATED AND INSTALLED FROM PRE     ="
	echo "=========================================="
	echo
	exit;
else
	TMP=$(mktemp)
	sudo find . -exec chmod 777 {} +
	cd depends
	echo
	echo "=========================================="
	echo "=        MAKE ON DEPENDS FOLDER          ="
	echo "=========================================="
	echo
	sleep 5
	if [[ ("${OPTION1^^}" == "WIN") ]]; then
		sudo make HOST=x86_64-w64-mingw32 2>&1 | tee $TMP
	else
		if [[ ("${OPTION1^^}" == "QT") ]]; then
			sudo make 2>&1 | tee $TMP
		else
			sudo make NO_QT=1 2>&1 | tee $TMP
		fi
	fi
	OUTPUT=$(cat $TMP)
	echo $OUTPUT
	rm $TMP
	cd ..
	echo
	echo "=========================================="
	echo "=           EXECUTING AUTOGEN            ="
	echo "=========================================="
	echo
	sudo find . -exec chmod 777 {} +
	sh autogen.sh 2>&1 | tee $TMP
	OUTPUT=$(cat $TMP)
	echo $OUTPUT
	if [[ $OUTPUT = *Error* ]]; then
		echo $OUTPUT 2>&1 >./ERROR.txt
		rm $TMP
		echo
		echo "************ AUTOGEN! Contains ERROR no compile good check ERROR.txt file!"
		echo
		exit 1
	fi
	rm $TMP
	echo
	echo "============================================"
	echo "=            EXECUTING CONFIGURE           ="
	echo "============================================"
	echo
	sudo find . -exec chmod 777 {} +
	sleep 5
	if [[ ("${OPTION1^^}" == "WIN") ]]; then
	#	./configure CC=gcc-8 CXX="g++-8" LDFLAGS="-lstdc++fs" --prefix=$(pwd)/depends/x86_64-w64-mingw32 2>&1 | tee $TMP
		#mkdir build
		#cd build
		CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/
		#cd ..
	else
		./configure CC=gcc-8 CXX="g++-8" LDFLAGS="-lstdc++fs" --prefix=$(pwd)/depends/x86_64-pc-linux-gnu 2>&1 | tee $TMP
	fi
	OUTPUT=$(cat $TMP)
	echo $OUTPUT
	if [[ $OUTPUT = *Error* ]]; then
		echo $OUTPUT 2>&1 >./ERROR.txt
		rm $TMP
		echo

		echo "********** CONFIGURE! Contains ERROR no compile good check ERROR.txt file!"
		echo
		exit 1
	fi
	if [ -f "$TMP" ]; then
		rm $TMP
	fi
	echo
	echo "=============================================="
	echo "=              EXECUTING MAKE                ="
	echo "=============================================="
	echo
	sudo find . -exec chmod 777 {} +
	sleep 5
	if [[ ("${OPTION1^^}" == "WIN") ]]; then
		sudo make install DESTDIR=/mnt/c/workspace/fuertecoin 2>&1 | tee $TMP
	else
		if [[ ("${OPTION1^^}" == "CPU" || "${OPTION2^^}" == "CPU") ]]; then
			if ! [[ $2 =~ '^[0-9]+$' ]]; then
				echo
				echo "=============================================="
				echo "=         SELECTED NUMBERS OF CPU $2         ="
				echo "=============================================="
				echo
				sudo make -j$2 2>&1 | tee $TMP
			elif ! [[ $3 =~ '^[0-9]+$' ]]; then
				sudo make -j$3 2>&1 | tee $TMP
			else
				echo
				echo "=============================================="
				echo "=         SELECTED NUMBERS OF CPU $3         ="
				echo "=============================================="
				echo
				sudo make 2>&1 | tee $TMP
			fi
		else
			sudo make 2>&1 | tee $TMP
		fi
	fi
	OUTPUT=$(cat $TMP)
	echo $OUTPUT
	if [[ $OUTPUT = *Error* ]]; then
		echo $OUTPUT 2>&1 >./ERROR.txt
		rm $TMP
		echo
		echo "*********** MAKE! Contains ERROR no compile good check ERROR.txt file!"
		echo
		exit 1
	fi
	rm $TMP
	if [[ ("${OPTION1^^}" == "WIN") ]]; then
		sudo make deploy
		sleep 3
		count=`ls -1 *.exe 2>/dev/null | wc -l`
		if [[ ("$count" != "0") ]]; then
			sudo cp $(ls -t1 . | head -1) /mnt/c/workspace/
		fi
	else
		cd src
		strip fuertecoind
		strip fuertecoin-tx
		strip fuertecoin-cli
	fi
fi