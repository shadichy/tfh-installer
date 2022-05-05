#!/bin/bash

# Configure the environment
workdir=`pwd`
declare -a target
target=( "AppImage" "script" )

declare -a arch
arch=( "x64" "ia32" )

declare -a os
os=( "linux" "mac" )

get_args(){
	while [[ "$1" ]];do
		case $1 in
			"--help" | "-h")
				printf "\n"
				printf "\e[1;44mUsage: ./build.sh [--help] [--clean] [--version] [--target=<target>] [--os=<os>]\e[1;m\n"
				printf "\n"
				printf "\e[1;44mOptions:\e[1;m\n"
				printf "\n"
				printf "\e[1;44m  -h,--help\e[1;m\t\t\tShow this help\n"
				printf "\e[1;44m  -c,--clean\e[1;m\t\t\tClean the build directory\n"
				printf "\e[1;44m  -V,--version\e[1;m\t\t\tShow the version\n"
				printf "\e[1;44m  -D,--build-dir=<dir>\e[1;m\t\tBuild the binaries in the specified directory (default: ${workdir})\n"
				printf "\e[1;44m  -t,--target=<target>\e[1;m\t\tBuild the specified target (default: all)\n"
				printf "\t\t\t\tSupported targets: $(for i in "${target[@]}";do [[ "${i}" != "${target[0]}" ]] && printf ", " ;printf "${i}";done)\n"
				printf "\e[1;44m  -s,--os=<os>\e[1;m\t\t\tBuild the specified os (default: all)\n"
				printf "\t\t\t\tSupported os: $(for i in "${os[@]}";do [[ "${i}" != "${os[0]}" ]] && printf ", " ;printf "${i}";done)\n"
				printf "\e[1;44m  -m,--arch=<arch>\e[1;m\t\tBuild the specified architecture (default: all)\n"
				printf "\t\t\t\tSupported architecture: $(for i in "${arch[@]}";do [[ "${i}" != "${arch[0]}" ]] && printf ", " ;printf "${i}";done)\n"
				printf "\e[1;44m  -d,--debug\e[1;m\t\t\tBuild the debug version\n"
				printf "\e[1;44m  -u,--update\e[1;m\t\t\tUpdate the binaries\n"
				printf "\n"
				exit 0
				;;
			"--clean" | "-c")
				update=true
				clean=true
				;;
			"--target="* | "-t="* | "-t" | "--target")
				# check if the target is included in the list
				# if contain "=", target_name=${1#*=}, else target_name=${2}
				[[ "${1}" == *"="* ]] && target_name=${1#*=} || target_name=${2}
				if [[ "${target_name}" == "all" ]];then
					target=( "${target[@]}" )
				else
					for i in "${target[@]}";do
						if [[ "${i}" == "${target_name}" ]];then
							target=( "${target[@]}" )
							break
						fi
					done
				fi
				if [[ "${target_name}" == "" ]];then
					printf "\e[1;41mError: --target=<target> or -t <target> is missing\e[1;m\n"
					exit 1
				fi
				if [[ "${target[@]}" =~ "${target_name}" ]];then
					target=( "${target_name}" )
				else
					printf "\e[1;41mError: target ${target_name} is not supported\e[1;m\n"
					exit 1
				fi
				;;
			"--os="* | "-s="* | "-s" | "--os")
				# check if the os is included in the list
				# if contain "=", os_name=${1#*=}, else os_name=${2}
				[[ "${1}" == *"="* ]] && os_name=${1#*=} || os_name=${2}
				if [[ "${os_name}" == "all" ]];then
					os=( "${os[@]}" )
				else
					for i in "${os[@]}";do
						if [[ "${i}" == "${os_name}" ]];then
							os=( "${os[@]}" )
							break
						fi
					done
				fi
				if [[ "${os_name}" == "" ]];then
					printf "\e[1;41mError: --os=<os> or -s <os> is missing\e[1;m\n"
					exit 1
				fi
				if [[ "${os[@]}" =~ "${os_name}" ]];then
					os=( "${os_name}" )
				else
					printf "\e[1;41mError: os ${os_name} is not supported\e[1;m\n"
					exit 1
				fi
				;;
			"--arch="* | "-m="* | "-m" | "--arch")
				# check if the arch is included in the list
				# if contain "=", arch_name=${1#*=}, else arch_name=${2}
				[[ "${1}" == *"="* ]] && arch_name=${1#*=} || arch_name=${2}
				if [[ "${arch_name}" == "all" ]];then
					arch=( "${arch[@]}" )
				else
					for i in "${arch[@]}";do
						if [[ "${i}" == "${arch_name}" ]];then
							arch=( "${arch[@]}" )
							break
						fi
					done
				fi
				if [[ "${arch_name}" == "" ]];then
					printf "\e[1;41mError: --arch=<arch> or -m <arch> is missing\e[1;m\n"
					exit 1
				fi
				#convert x86_64 to x64; i686, i386, pentium4 to ia32
				case ${arch_name} in
					"x86_64")
						arch_name="x64"
						;;
					"i686" | "i386" | "pentium4")
						arch_name="ia32"
						;;
					*)
						printf "\e[1;41mError: arch ${arch_name} is not supported\e[1;m\n"
						exit 1
						;;
				esac
				if [[ "${arch[@]}" =~ "${arch_name}" ]];then
					arch=( "${arch_name}" )
				else
					printf "\e[1;41mError: arch ${arch_name} is not supported\e[1;m\n"
					exit 1
				fi
				;;
			"--debug" | "-d")
				node_args="debug"
				;;
			"--update" | "-u")
				update=true
				;;
			"--build-dir="*)
				workdir=( "${1#*=}" )
				;;
			"-D" | "--build-dir")
				workdir=$2
				shift
				;;
			"--version" | "-V")
				printf "Current binaries version:\t$(neu version | grep 'Neutralinojs bin')\n\t\t\t\t$(neu version | grep 'Neutralinojs cli')\n"
				printf "Current app version:\t\t$(cat ${workdir}/neutralino.config.json | grep '"version":' | sed 's/  "version": "//g' | sed 's/",//g')\n"
				exit 0
				;;
		esac
		shift;
	done
}

cd ${workdir}

get_args "$@"

# Copy Folders to ./out
cp -r ./resources/fonts ./out/resources/
cp -r ./resources/icons ./out/resources/
cp -r ./resources/res ./out/resources/

if [[ ! "$(ls -A ./bin)" ]];then
		# running for the first time
	printf 	"\e[1;44mRunning for the first time\e[1;m\n"
	update=true
fi

printf "\e[1;44mCompiling the source...\e[1;m\n"
node ./index.js ${node_args}

cd out

# Check if update variable is true then run `neu update`
if [[ "${update}" == true ]];then
	printf "\e[1;44mUpdating the binaries...\e[1;m\n"
	neu update
	# check for yarn/pnpm/npm then run update command
	if ! pnpm update;then
		if ! yarn update;then
			npm update
		fi
	fi
else
	cp -r ../bin .
	cp -r ../resources/js/neutralino.js ./resources/js/
fi

printf "\e[1;44mBuilding the binaries...\e[1;m\n"

neu build

cd dist/hpvn/
mv ../../resources/res/pack.png .
cp ../../../resources/scripts/* .
chmod +x install
chmod +x checkmc
chmod +x neofetch
chmod +x script.sh

for i in "${os[@]}"; do
	for m in "${arch[@]}";do
		# if is mac and is 32bit, then skip
		if [[ "${i}" == "mac" && "${m}" == "ia32" ]];then
			continue
		fi
		# copy binaries from ../../bin to ., rename to hpvn-<os>_<arch>
		cp -r ../../bin/neutralino-${i}_${m} ./hpvn-${i}_${m}
		for x in "${target[@]}"; do
			if [ "${x}" = "AppImage" ]; then
				if [ "${i}" = "mac" ]; then
					continue
				fi
				current_dir=$(pwd)
				cd ../build/
				if [ ! -d "HappyVietnam.AppDir" ]; then
					mkdir "HappyVietnam.AppDir"
				fi
				# convert x64 to x86_64, ia32 to i386
				machine=${m//x64/x86_64}
				machine=${machine//ia32/i686}

				if [ -f "../build/Happy_Vietnam_Installer-${machine}.AppImage" ]; then
					printf "\e[1;44mRemove old AppImage\e[1;m\n"
					rm "../build/Happy_Vietnam_Installer-${machine}.AppImage"
				fi
				printf "\e[1;44mBuilding AppImage...\e[1;m\n"
				cd "HappyVietnam.AppDir"
				cat << EOF > AppRun
#!/bin/sh

cd "\$(dirname "\$0")"
exec ./hpvn-${i}_${m}
EOF
				cp ../../hpvn/hpvn-${i}_${m} .
				chmod +x hpvn-${i}_${m}
				chmod +x AppRun
				cat << EOF > HappyVietnam.desktop
[Desktop Entry]
Name=Happy Vietnam Installer
Comment=Bộ cài đặt Gói tài nguyên và Bản đồ Happy Vietnam Minecraft
Icon=appIcon
Terminal=false
Type=Application
Categories=Education;
X-AppImage-Version=1.0
X-AppImage-Name=HappyVietnam
X-AppImage-Arch=${machine}
EOF
				cp ../../hpvn/install .
				cp ../../../resources/icons/appIcon.png .
				cp ../../hpvn/checkmc .
				cp ../../hpvn/neofetch .
				cp ../../hpvn/resources.neu .
				cp ../../hpvn/pack.png .
				cd ../
				[[ ! -f ../appimagetool-${machine}.AppImage ]] && curl -L -o ../appimagetool-${machine}.AppImage https://github.com/AppImage/AppImageKit/releases/latest/download/appimagetool-${machine}.AppImage
				chmod +x ../appimagetool-${machine}.AppImage
				ARCH=${machine} ../appimagetool-${machine}.AppImage $(pwd)/HappyVietnam.AppDir # --mksquashfs-opt -quiet
				rm -rf HappyVietnam.AppDir
				cd ${current_dir}
			
		fi
		if [ "${x}" = "script" ]; then
			# if os is mac and arch is ia32 then skip
			if [ "${i}" = "mac" ] && [ "${m}" = "ia32" ]; then
				continue
			fi
			printf "\e[1;44mCreate script for ${i} ${m}\e[1;m\n"
			tar -zcvf hpvn-${i}_${m}.tar.gz install neofetch checkmc resources.neu hpvn-${i}_${m} pack.png
			rm -f ../build/hpvn-${i}_${m}.sh
			cat script.sh | sed -e "s/\${arch}/${m}/g" | sed -e "s/\${os}/${i}/g" > ../build/hpvn-${i}_${m}.sh
			cat hpvn-${i}_${m}.tar.gz >> ../build/hpvn-${i}_${m}.sh
			chmod +x ../build/hpvn-${i}_${m}.sh
			rm -f hpvn-${i}_${m}.tar.gz
		fi
	done
	done
done

# clean
if [ "${clean}" = true ]; then
	printf "\e[1;44mCleaning...\e[1;m\n"
	rm -rf ./*
	rm -rf ../*.AppImage
	rm -rf ../../resources/res
	rm -rf ../../resources/fonts
	rm -rf ../../resources/icons
	rm -rf ../../resources/index.html
	rm -rf ../../resources/styles.css
	rm -rf ../../bin
fi

printf "\e[1;44mBuilds are made in ${workdir}/out/dist/build\e[1;m\n"
printf "\e[1;44mDone!\e[1;m\n"
cd ${workdir}
