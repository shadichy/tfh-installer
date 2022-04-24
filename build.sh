#!/bin/sh

# Configure the environment
workdir=`pwd`
declare -a target
target=( "AppImage" "script" )

machine=$(uname -m)

declare -a os
os=( "linux" "mac" )

get_args(){
	while [[ "$1" ]];do
		case $1 in
			"--help" | "-h")
				echo -e ""
				echo -e "\e[1;44mUsage: ./build.sh [--help] [--clean] [--version] [--target=<target>] [--os=<os>]\e[1;m"
				echo -e ""
				echo -e "\e[1;44mOptions:\e[1;m"
				echo -e ""
				echo -e "\e[1;44m  -h,--help\e[1;m\t\t\tShow this help"
				echo -e "\e[1;44m  -c,--clean\e[1;m\t\t\tClean the build directory"
				echo -e "\e[1;44m  -V,--version\e[1;m\t\t\tShow the version"
				echo -e "\e[1;44m  -D,--build-dir=<dir>\e[1;m\t\tBuild the binaries in the specified directory (default: ${workdir})"
				echo -e "\e[1;44m  -t,--target=<target>\e[1;m\t\tBuild the specified target (default: all)"
				echo -e "\t\t\t\tSupported targets: $(for i in "${target[@]}";do [[ "${i}" != "${target[0]}" ]] && printf ", " ;printf "${i}";done)"
				echo -e "\e[1;44m  -s,--os=<os>\e[1;m\t\t\tBuild the specified os (default: all)"
				echo -e "\t\t\t\tSupported os: $(for i in "${os[@]}";do [[ "${i}" != "${os[0]}" ]] && printf ", " ;printf "${i}";done)"
				echo -e "\e[1;44m  -m,--arch=<arch>\e[1;m\t\t\tBuild the specified architecture (default: ${machine})"
				echo -e "\t\t\t\tSupported architecture: x86_64, i686"
				echo -e "\e[1;44m  -d,--debug\e[1;m\t\t\tBuild the debug version"
				echo -e "\e[1;44m  -u,--update\e[1;m\t\t\tUpdate the binaries"declare -pdeclare -p
				echo -e ""
				exit 0
				;;
			"--clean" | "-c")
				clean=true
				;;
			"--target="*)
				target=( "${1#*=}" )
				;;
			"-t")
				target=$2
				;;
			"--os="*)
				os=( "${1#*=}" )
				;;
			"-s")
				os=$2
				;;
			"--arch="*)
				machine=( "${1#*=}" )
				;;
			"-m")
				machine=$2
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
			"-D")
				workdir=$2
				;;
			"--version" | "-V")
				echo -e "Current binaries version:\t$(neu version | grep 'Neutralinojs bin')\n\t\t\t\t$(neu version | grep 'Neutralinojs cli')"
				echo -e "Current app version:\t\t$(cat ${workdir}/neutralino.config.json | grep '"version":' | sed 's/  "version": "//g' | sed 's/",//g')"
				exit 0
				;;
		esac
		shift;
	done
}

case ${machine} in
	"x86_64")
		arch="x64"
		;;
	"i686")
		arch="ia32"
		;;
	*)
		echo -e "\e[1;44mUnsupported architecture: ${machine}\e[1;m"
		exit 1
		;;
esac

cd ${workdir}

get_args "$@"

# Copy Folders to ./out
cp -r ./resources/fonts ./out/resources/
cp -r ./resources/icons ./out/resources/
cp -r ./resources/res ./out/resources/
echo -e "\e[1;44mCompiling the source...\e[1;m"
node ./index.js ${node_args}

cd out

echo -e "\e[1;44mBuilding the binaries...\e[1;m"
# Check if update variable is true then run `neu update`
if [[ "${update}" == true ]];then
	echo -e "\e[1;44mUpdating the binaries...\e[1;m"
	neu update
	pnpm update
fi

neu build

cd dist/hpvn/
mv ../../resources/res/pack.png .
cp ../../../resources/scripts/* .
chmod +x install
chmod +x checkmc
chmod +x neofetch
chmod +x script.sh

for i in "${os[@]}"; do 
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
			if [ -f "../build/Happy_Vietnam_Installer-${machine}.AppImage" ]; then
				echo -e "\e[1;44mRemove old AppImage\e[1;m"
				rm "../build/Happy_Vietnam_Installer-${machine}.AppImage"
			fi
			echo -e "\e[1;44mBuilding AppImage...\e[1;m"
			cd "HappyVietnam.AppDir"
			cat << EOF > AppRun
#!/bin/sh

cd "\$(dirname "\$0")"
exec ./hpvn-${i}_${arch}
EOF
			cp ../../hpvn/hpvn-${i}_${arch} .
			chmod +x hpvn-${i}_${arch}
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
			cp ../../../resources/icons/appIcon.png .
			cp ../../hpvn/install .
			cp ../../hpvn/checkmc .
			cp ../../hpvn/neofetch .
			cp ../../hpvn/resources.neu .
			cp ../../hpvn/pack.png .
			cd ../
			[[ ! -f ../appimagetool-${machine}.AppImage ]] && curl -L -o ../appimagetool-${machine}.AppImage https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-${machine}.AppImage
			chmod +x ../appimagetool-${machine}.AppImage
			ARCH=${machine} ../appimagetool-${machine}.AppImage $(pwd)/HappyVietnam.AppDir  --mksquashfs-opt -quiet
			rm -rf HappyVietnam.AppDir
			cd ${current_dir}
			
		fi
		if [ "${x}" = "script" ]; then
			echo -e "\e[1;44mCreate script for ${i} ${arch}\e[1;m"
			tar -zcvf hpvn-${i}_${arch}.tar.gz install neofetch checkmc resources.neu hpvn-${i}_${arch} pack.png
			rm -f ../build/hpvn-${i}_${arch}.sh
			cat script.sh | sed -e "s/\${arch}/${arch}/g" | sed -e "s/\${os}/${i}/g" > ../build/hpvn-${i}_${arch}.sh
			cat hpvn-${i}_${arch}.tar.gz >> ../build/hpvn-${i}_${arch}.sh
			chmod +x ../build/hpvn-${i}_${arch}.sh
			rm hpvn-${i}_${arch}.tar.gz
		fi
	done
done

# clean
if [ "${clean}" = true ]; then
	echo -e "\e[1;44mCleaning...\e[1;m"
	rm -rf ./*
	rm -rf ../*.AppImage
	rm -rf ../../resources/res
	rm -rf ../../resources/fonts
	rm -rf ../../resources/icons
	rm -rf ../../resources/index.html
	rm -rf ../../resources/styles.css
fi

echo -e "\e[1;44mDone!\e[1;m"
cd ${workdir}
