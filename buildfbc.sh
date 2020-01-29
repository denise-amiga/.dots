set -e

m_gcc_ver="8.1.0"
m_fbc_ver="1.08.0"
m_date=$(date +%F)

usage(){
	echo "usage: ./makefbc 32|64 normal|standalone [--zip] [--clean]"
	exit 1
}

clean(){
	echo "Cleaning ..."
	rm -rf _build_/fb-$m_fbc_ver-32-normal-$m_date
	rm -rf _build_/fb-$m_fbc_ver-64-normal-$m_date
	rm -rf _build_/fb-$m_fbc_ver-32-standalone-$m_date
	rm -rf _build_/fb-$m_fbc_ver-64-standalone-$m_date
}

buildex32n(){
	echo "building 32 bits (normal)"
	mkdir -p _build_
	cd _build_
	[[ -d fb-$m_fbc_ver-32-normal-$m_date ]] && rm -rf fb-$m_fbc_ver-32-normal-$m_date
	mkdir -p fb-$m_fbc_ver-32-normal-$m_date
	cd fb-$m_fbc_ver-32-normal-$m_date
	make -j4 -f ../../makefile TARGET_ARCH=x86 ENABLE_STRIPALL=1 FBC="fbc32 -i ../../inc"
	mv bin/fbc.exe bin/fbc1.exe
	rm src/compiler/obj/win32/*.o
	make -j4 -f ../../makefile TARGET_ARCH=x86 ENABLE_STRIPALL=1 FBC="./bin/fbc1 -i ../../inc"
	mv bin/fbc.exe bin/fbc32.exe
	mkdir -p include/freebasic
	cp -r ../../inc/* include/freebasic
	rm bin/fbc1.exe
	rm -rf src
	cd ..
	if [[ "$m_zip" = "Y" ]]; then
		echo "Zipping..."
		rm -rf fb-$m_fbc_ver-32-normal-$m_date.zip
		zip -q -r fb-$m_fbc_ver-32-normal-$m_date.zip fb-$m_fbc_ver-32-normal-$m_date
	fi
	cd ..
}

buildex32s(){
	echo "building 32 bits (standalone)"
	mkdir -p _build_
	cd _build_
	[[ -d fb-$m_fbc_ver-32-standalone-$m_date ]] && rm -rf fb-$m_fbc_ver-32-standalone-$m_date
	mkdir -p fb-$m_fbc_ver-32-standalone-$m_date
	cd fb-$m_fbc_ver-32-standalone-$m_date
	make -j4 -f ../../makefile TARGET_ARCH=x86 ENABLE_STRIPALL=1 ENABLE_STANDALONE=1 FBC="fbc32 -i ../../inc"
	mv fbc.exe fbc1.exe
	rm src/compiler/obj/win32/*.o
	mkdir -p bin/win32 bin/libexec/gcc/$MINGW_CHOST/$m_gcc_ver
	cp $MINGW/bin/{ar,as,ld,dlltool,gcc}.exe bin/win32
	cp $MINGW/bin/lib{gcc_s_sjlj-1,winpthread-1}.dll bin/win32
	cp $MINGW/libexec/gcc/$MINGW_CHOST/$m_gcc_ver/cc1.exe bin/libexec/gcc/$MINGW_CHOST/$m_gcc_ver
	cp $MINGW/bin/libwinpthread-1.dll bin/libexec/gcc/$MINGW_CHOST/$m_gcc_ver
	cp $MINGW/$MINGW_CHOST/lib/{crt2,dllcrt2,gcrt2}.o lib/win32
	cp $MINGW/$MINGW_CHOST/lib/lib{gmon,mingw32,mingwex,moldname}.a lib/win32
	cp $MINGW/$MINGW_CHOST/lib/lib{advapi32,gdi32,kernel32,msvcrt,user32,winmm,winspool}.a lib/win32
	cp $MINGW/lib/gcc/$MINGW_CHOST/$m_gcc_ver/crt{begin,end}.o lib/win32
	cp $MINGW/lib/gcc/$MINGW_CHOST/$m_gcc_ver/libgcc.a lib/win32
	make -j4 -f ../../makefile TARGET_ARCH=x86 ENABLE_STRIPALL=1 ENABLE_STANDALONE=1 FBC="./fbc1 -i ../../inc"
	mv fbc.exe fbc32s.exe
	mkdir -p inc
	cp -r ../../inc/* inc
	rm fbc1.exe
	rm -rf src
	cd ..
	if [[ "$m_zip" = "Y" ]]; then
		echo "Zipping..."
		rm -rf fb-$m_fbc_ver-32-standalone-$m_date.zip
		zip -q -r fb-$m_fbc_ver-32-standalone-$m_date.zip fb-$m_fbc_ver-32-standalone-$m_date
	fi
	cd ..
}

buildex64n(){
	echo "building 64 bits (normal)"
	mkdir -p _build_
	cd _build_
	[[ -d fb-$m_fbc_ver-64-normal-$m_date ]] && rm -rf fb-$m_fbc_ver-64-normal-$m_date
	mkdir -p fb-$m_fbc_ver-64-normal-$m_date
	cd fb-$m_fbc_ver-64-normal-$m_date
	make -j4 -f ../../makefile ENABLE_STRIPALL=1 FBC="fbc64 -i ../../inc"
	mv bin/fbc.exe bin/fbc1.exe
	rm src/compiler/obj/win64/*.o
	make -j4 -f ../../makefile ENABLE_STRIPALL=1 FBC="./bin/fbc1 -i ../../inc"
	mv bin/fbc.exe bin/fbc64.exe
	mkdir -p include/freebasic
	cp -r ../../inc/* include/freebasic
	rm bin/fbc1.exe
	rm -rf src
	cd ..
	if [[ "$m_zip" = "Y" ]]; then
		echo "Zipping..."
		rm -rf fb-$m_fbc_ver-64-normal-$m_date.zip
		zip -q -r fb-$m_fbc_ver-64-normal-$m_date.zip fb-$m_fbc_ver-64-normal-$m_date
	fi
	cd ..
}

buildex64s(){
	echo "building 64 bits (standalone)"
	mkdir -p _build_
	cd _build_
	[[ -d fb-$m_fbc_ver-64-standalone-$m_date ]] && rm -rf fb-$m_fbc_ver-64-standalone-$m_date
	mkdir -p fb-$m_fbc_ver-64-standalone-$m_date
	cd fb-$m_fbc_ver-64-standalone-$m_date
	make -j4 -f ../../makefile ENABLE_STRIPALL=1 ENABLE_STANDALONE=1 FBC="fbc64 -i ../../inc"
	mv fbc.exe fbc1.exe
	rm src/compiler/obj/win64/*.o
	mkdir -p bin/win64 bin/libexec/gcc/$MINGW_CHOST/$m_gcc_ver
	cp $MINGW/bin/{ar,as,ld,dlltool,gcc}.exe bin/win64
	cp $MINGW/bin/lib{gcc_s_seh-1,winpthread-1}.dll bin/win64
	cp $MINGW/libexec/gcc/$MINGW_CHOST/$m_gcc_ver/cc1.exe bin/libexec/gcc/$MINGW_CHOST/$m_gcc_ver
	cp $MINGW/bin/libwinpthread-1.dll bin/libexec/gcc/$MINGW_CHOST/$m_gcc_ver
	cp $MINGW/$MINGW_CHOST/lib/{crt2,dllcrt2,gcrt2}.o lib/win64
	cp $MINGW/$MINGW_CHOST/lib/lib{gmon,mingw32,mingwex,moldname}.a lib/win64
	cp $MINGW/$MINGW_CHOST/lib/lib{advapi32,gdi32,kernel32,msvcrt,user32,winmm,winspool}.a lib/win64
	cp $MINGW/lib/gcc/$MINGW_CHOST/$m_gcc_ver/crt{begin,end}.o lib/win64
	cp $MINGW/lib/gcc/$MINGW_CHOST/$m_gcc_ver/libgcc.a lib/win64
	make -j4 -f ../../makefile ENABLE_STRIPALL=1 ENABLE_STANDALONE=1 FBC="./fbc1 -i ../../inc"
	mv fbc.exe fbc64s.exe
	mkdir -p inc
	cp -r ../../inc/* inc
	rm fbc1.exe
	rm -rf src
	cd ..
	if [[ "$m_zip" = "Y" ]]; then
		echo "Zipping..."
		rm -rf fb-$m_fbc_ver-64-standalone-$m_date.zip
		zip -q -r fb-$m_fbc_ver-64-standalone-$m_date.zip fb-$m_fbc_ver-64-standalone-$m_date
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
