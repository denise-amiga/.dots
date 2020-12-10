## requirements:
##   - Mingw-w64
##       - 32 bits -> (https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/8.1.0/threads-posix/sjlj/i686-8.1.0-release-posix-sjlj-rt_v6-rev0.7z)
##       - 64 bits -> (https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-posix/seh/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z)
##   - MSYS2
##       - 32 bits -> (http://repo.msys2.org/distrib/i686/msys2-i686-20190524.exe)
##       - 64 bits -> (http://repo.msys2.org/distrib/x86_64/msys2-x86_64-20190524.exe)
##   - Lib FFI
##       - 32 bits -> (https://sourceforge.net/projects/fbc/files/Tools/Libraries/libffi-3.0.13-win32-mingw-w64.7z/download)
##       - 64 bits -> (https://sourceforge.net/projects/fbc/files/Tools/Libraries/libffi-3.0.13-win64-mingw-w64.7z/download)
##   - $MINGW variable pointing to the correct compiler architecture.
##       Helper script for bash/zsh:
##          function setgcc(){
##                  if [[ $MSYSTEM == MINGW64 ]]; then
##                          export MINGW=/e/BmxNg/mingw64 ;
##                          PATH=$PATH:$MINGW/bin ;
##                  fi
##                  if [[ $MSYSTEM == MINGW32 ]]; then
##                          export MINGW=/e/BmxNg/mingw32 ;
##                          PATH=$PATH:$MINGW/bin ;
##                  fi
##          }

set -e

V_GCC="8.1.0"
V_FBC="1.08.0"
V_DATE=$(date +%F)
M_FLAGS="FBSHA1=1 ENABLE_STRIPALL=1"

usage(){
	echo "usage: ./buildfbc 32|64 normal|standalone|both [--zip] [--clean]"
	exit 1
}

clean(){
	echo "Cleaning ..."
	rm -rf _build_/fb-$V_FBC-32-normal-$V_DATE
	rm -rf _build_/fb-$V_FBC-64-normal-$V_DATE
	rm -rf _build_/fb-$V_FBC-32-standalone-$V_DATE
	rm -rf _build_/fb-$V_FBC-64-standalone-$V_DATE
}

buildex32n(){
	M_FILE=fb-$V_FBC-32-normal-$V_DATE
	echo "building 32 bits (normal)"
	mkdir -p _build_ && cd _build_
	[[ -d $M_FILE ]] && rm -rf $M_FILE
	mkdir -p $M_FILE && cd $M_FILE
	make -j4 -f ../../makefile TARGET_ARCH=x86 $M_FLAGS FBC="fbc -i ../../inc"
	mv bin/fbc.exe bin/fbc1.exe
	rm src/compiler/obj/win32/*.o
	make -j4 -f ../../makefile TARGET_ARCH=x86 $M_FLAGS FBC="./bin/fbc1 -i ../../inc"
	#mv bin/fbc.exe bin/fbc32.exe
	mkdir -p include/freebasic
	cp -r ../../inc/* include/freebasic
	rm bin/fbc1.exe
	cd ..
	if [[ "$m_zip" = "Y" ]]; then
		echo "Zipping..."
		[[ "$m_clean" = "Y" ]] && rm -rf $M_FILE/src
		rm -rf $M_FILE.zip
		zip -q -r $M_FILE.zip $M_FILE
	fi
	cd ..
}

buildex32s(){
	M_FILE=fb-$V_FBC-32-standalone-$V_DATE
	echo "building 32 bits (standalone)"
	mkdir -p _build_ && cd _build_
	[[ -d $M_FILE ]] && rm -rf $M_FILE
	mkdir -p $M_FILE && cd $M_FILE
	make -j4 -f ../../makefile TARGET_ARCH=x86 $M_FLAGS ENABLE_STANDALONE=1 FBC="fbc -i ../../inc"
	mv fbc.exe fbc1.exe
	rm src/compiler/obj/win32/*.o
	mkdir -p bin/win32 bin/libexec/gcc/$MINGW_CHOST/$V_GCC
	cp $MINGW/bin/{ar,as,ld,dlltool,gcc}.exe bin/win32
	cp $MINGW/bin/lib{gcc_s_sjlj-1,winpthread-1}.dll bin/win32
	cp $MINGW/libexec/gcc/$MINGW_CHOST/$V_GCC/cc1.exe bin/libexec/gcc/$MINGW_CHOST/$V_GCC
	cp $MINGW/bin/libwinpthread-1.dll bin/libexec/gcc/$MINGW_CHOST/$V_GCC
	cp $MINGW/$MINGW_CHOST/lib/{crt2,dllcrt2,gcrt2}.o lib/win32
	cp $MINGW/$MINGW_CHOST/lib/lib{gmon,mingw32,mingwex,moldname}.a lib/win32
	cp $MINGW/$MINGW_CHOST/lib/lib{advapi32,gdi32,kernel32,msvcrt,user32,winmm,winspool}.a lib/win32
	cp $MINGW/lib/gcc/$MINGW_CHOST/$V_GCC/crt{begin,end}.o lib/win32
	cp $MINGW/lib/gcc/$MINGW_CHOST/$V_GCC/libgcc.a lib/win32
	make -j4 -f ../../makefile TARGET_ARCH=x86 $M_FLAGS ENABLE_STANDALONE=1 FBC="./fbc1 -i ../../inc"
	mv fbc.exe fbc32s.exe
	mkdir -p inc
	cp -r ../../inc/* inc
	rm fbc1.exe
	cd ..
	if [[ "$m_zip" = "Y" ]]; then
		echo "Zipping..."
		[[ "$m_clean" = "Y" ]] && rm -rf $M_FILE/src
		rm -rf $M_FILE.zip
		zip -q -r $M_FILE.zip $M_FILE
	fi
	cd ..
}

buildex64n(){
	M_FILE=fb-$V_FBC-64-normal-$V_DATE
	echo "building 64 bits (normal)"
	mkdir -p _build_ && cd _build_
	[[ -d $M_FILE ]] && rm -rf $M_FILE
	mkdir -p $M_FILE && cd $M_FILE
	make -j4 -f ../../makefile $M_FLAGS FBC="fbc -i ../../inc"
	mv bin/fbc.exe bin/fbc1.exe
	rm src/compiler/obj/win64/*.o
	make -j4 -f ../../makefile $M_FLAGS FBC="./bin/fbc1 -i ../../inc"
	#mv bin/fbc.exe bin/fbc64.exe
	mkdir -p include/freebasic
	cp -r ../../inc/* include/freebasic
	rm bin/fbc1.exe
	cd ..
	if [[ "$m_zip" = "Y" ]]; then
		echo "Zipping..."
		[[ "$m_clean" = "Y" ]] && rm -rf $M_FILE/src
		rm -rf $M_FILE.zip
		zip -q -r $M_FILE.zip $M_FILE
	fi
	cd ..
}

buildex64s(){
	M_FILE=fb-$V_FBC-64-standalone-$V_DATE
	echo "building 64 bits (standalone)"
	mkdir -p _build_ && cd _build_
	[[ -d $M_FILE ]] && rm -rf $M_FILE
	mkdir -p $M_FILE && cd $M_FILE
	make -j4 -f ../../makefile $M_FLAGS ENABLE_STANDALONE=1 FBC="fbc -i ../../inc"
	mv fbc.exe fbc1.exe
	rm src/compiler/obj/win64/*.o
	mkdir -p bin/win64 bin/libexec/gcc/$MINGW_CHOST/$V_GCC
	cp $MINGW/bin/{ar,as,ld,dlltool,gcc}.exe bin/win64
	cp $MINGW/bin/lib{gcc_s_seh-1,winpthread-1}.dll bin/win64
	cp $MINGW/libexec/gcc/$MINGW_CHOST/$V_GCC/cc1.exe bin/libexec/gcc/$MINGW_CHOST/$V_GCC
	cp $MINGW/bin/libwinpthread-1.dll bin/libexec/gcc/$MINGW_CHOST/$V_GCC
	cp $MINGW/$MINGW_CHOST/lib/{crt2,dllcrt2,gcrt2}.o lib/win64
	cp $MINGW/$MINGW_CHOST/lib/lib{gmon,mingw32,mingwex,moldname}.a lib/win64
	cp $MINGW/$MINGW_CHOST/lib/lib{advapi32,gdi32,kernel32,msvcrt,user32,winmm,winspool}.a lib/win64
	cp $MINGW/lib/gcc/$MINGW_CHOST/$V_GCC/crt{begin,end}.o lib/win64
	cp $MINGW/lib/gcc/$MINGW_CHOST/$V_GCC/libgcc.a lib/win64
	make -j4 -f ../../makefile $M_FLAGS ENABLE_STANDALONE=1 FBC="./fbc1 -i ../../inc"
	mv fbc.exe fbc64s.exe
	mkdir -p inc
	cp -r ../../inc/* inc
	rm fbc1.exe
	cd ..
	if [[ "$m_zip" = "Y" ]]; then
		echo "Zipping..."
		[[ "$m_clean" = "Y" ]] && rm -rf $M_FILE/src
		rm -rf $M_FILE.zip
		zip -q -r $M_FILE.zip $M_FILE
	fi
	cd ..
}

build(){
	if [[ ( "$1" = "32" ) && ( "$2" = "normal" ) ]]; then
		buildex32n
	elif [[ ( "$1" = "64" ) && ( "$2" = "normal" ) ]]; then
		buildex64n
	elif [[ ( "$1" = "32" ) && ( "$2" = "standalone" ) ]]; then
		buildex32s
	elif [[ ( "$1" = "64" ) && ( "$2" = "standalone" ) ]]; then
		buildex64s
	elif [[ "$2" = "both" ]]; then
		if [[ "$1" = "32" ]]; then
			buildex32n
			buildex32s
		elif [[ "$1" = "64" ]]; then
			buildex64n
			buildex64s
		fi
	fi
}

# parse command line arguments
while [[ $# -gt 0 ]]
do
	arg="$1"
	case $arg in
		32|64)
			m_arch="$1"
			shift
			;;
		normal|standalone|both)
			m_build="$1"
			shift
			;;
		--zip|-zip|-z)
			m_zip="Y"
			shift
			;;
		--clean|-clean|-c)
			m_clean="Y"
			shift
			;;
		--help|-help|-h)
			m_help="Y"
			shift
			;;
		*)
			shift
			;;
	esac
done

[[ "$m_help" = "Y" ]] && usage

if [ -z "$m_arch" -o -z "$m_build" ]; then
	if [[ "$m_clean" = "Y" ]]; then
		clean
		exit 0
	fi
	usage
fi

if [[ ( "$MSYSTEM" = "MINGW32" && "$m_arch" = "64" ) || ( "$MSYSTEM" = "MINGW64" && "$m_arch" = "32" ) ]]; then
	echo "Sorry, only native builds"
	exit 2
fi

build "$m_arch" "$m_build"

[[ "$m_clean" = "Y" ]] && clean
exit 0
