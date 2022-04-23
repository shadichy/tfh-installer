#!/bin/sh

# Configure the environment
echo -e "\e[1;44mPreparing the environment...\e[1;m"
workdir=`pwd`
declare -a target
target=( "AppImage" "script" )
machine=$(uname -m)
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
# ( "x86_64" "i686" )
declare -a os
os=( "linux" "mac" )

case "${1}" in
	"--debug")
		node_args="debug"
		;;
esac

cd ${workdir}

# Copy Folders to ./out
cp -r ./resources/fonts ./out/resources/
cp -r ./resources/icons ./out/resources/
cp -r ./resources/res ./out/resources/
echo -e "\e[1;44mCompiling the source...\e[1;m"
node ./index.js ${node_args}

cd out

echo -e "\e[1;44mBuilding the binaries...\e[1;m"
neu update
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

echo -e "\e[1;44mDone!\e[1;m"
cd ${workdir}
